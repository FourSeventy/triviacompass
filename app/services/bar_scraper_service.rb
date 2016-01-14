require 'mechanize'
require 'http'

class BarScraperService

  def initialize

  end

  ## Scrape the Geeks Who Drink bar listing page for bar data
  def scrape_geeks

    #make get request to geeks page
    mechanize = Mechanize.new
    page = mechanize.get('http://www.geekswhodrink.com/pages/venues?action=getAll')

    #initialize array to hold our list of bars
    bar_array = []

    #get all bar anchors
    bar_a = page.search('#content a')

    #iterate over all bar anchors
    bar_a.each do |result|

      bar = Bar.new
      bar.name = result.text

      #figure out address
      address_parts = result['title'].split('|')
      bar.address = address_parts[0]
      city_state_zip = address_parts[1].split(' ')
      bar.city = city_state_zip[0..-3].join(' ')
      bar.state = city_state_zip[-2]
      bar.zip = city_state_zip[-1]

      #fix zip edge case where leading 0 gets cut off
      if bar.zip.length < 5
        bar.zip.prepend '0'
      end

      #find previous h1 for the day
      bar.trivia_day = result.at_xpath('(preceding-sibling::h1 | preceding-sibling::*//h1)[last()]').text

      #find time
      span =  result.at_xpath('following-sibling::span')
      trivia_time_node = span.at_xpath('following-sibling::text()')
      bar.trivia_time = trivia_time_node.text

      #set trivia type
      bar.trivia_type = 'geeks'

      #check if bar is an upcoming bar
      b = trivia_time_node.next
      upcoming = !b.nil? && b.name == 'b' && b.text.include?('Starts')

      #add bar to array as long as its not upcoming
      unless upcoming
        bar_array.push bar
      end
    end


    #populate bar lat and long, rate limited to 10 per second
    make_multiple_requests(bar_array) do |bar|
      bar.populateLocation
    end

    #return array of bars
    return bar_array

  end


  def scrape_stump

    #make request to stump endpoint
    url = 'http://www.stumptrivia.com/shared/api/index.php'
    body = 'service=SiteService&operation=MultiEventFinder&data=%7B%22ReturnIndex%22%3A1%2C%22ReturnCount%22%3A10000%2C%22FocusWeekday%22%3A-1%2C%22EventTypes%22%3A%5B%22StumpLiveTrivia%22%2C%22StumpLiveQuestionnairey%22%2C%22StumpTriviaInABox%22%2C%22StumpQuestionnaireyInABox%22%5D%2C%22ReturnEventsRequired%22%3A1%2C%22SearchLatitude%22%3A37.09024%2C%22SearchLongitude%22%3A-95.71289100000001%2C%22SearchDistance%22%3A50000000%2C%22UseTwoPass%22%3Afalse%7D'
    raw_response = HTTP.headers("Content-Type" => "application/x-www-form-urlencoded").post(url, :body => body)

    #parse response to a hash
    response = JSON.parse raw_response.to_s

    #handle bad response
    if raw_response.code != 200
      Rails.logger.error('Error scraping stump bars')
      Rails.logger.error(raw_response.reason)
    end

    #parse response into bar objects
    bar_list = []
    day_list = response['DayList']['DayEvents']

    #iterate over days
    day_map = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday']
    day_list.each_with_index do |item, index|

      #get day of trivia
      day = day_map[index]

      #iterate over bar array
      bar_array = item['EventSiteList']['EventSiteGeoCode']
      unless bar_array.nil?
        bar_array.each do |bar_data|

          #build bar
          bar = Bar.new
          bar.trivia_day = day
          bar.trivia_time = bar_data['EventStartTime']
          bar.name = bar_data['SiteName']
          bar.lat = bar_data['Latitude']
          bar.long = bar_data['Longitude']
          address = bar_data['Location']['Address']
          bar.address = "#{address['StreetAddress1']}  #{address['StreetAddress2']}"
          bar.city = address['City']['Name']
          bar.state = address['State']['Name']
          bar.zip = address['ZipCode']['ZipCodeValue']
          bar.trivia_type = 'stump'
          #TODO: parse phone number

          #push bar to list
          bar_list.push bar
        end
      end

    end

    #return bar list
    return bar_list

  end

  def scrape_brain

    #make get request to geeks page
    mechanize = Mechanize.new
    page = mechanize.get('http://www.brainstormer.com/venuelist.aspx')

    #initialize array to hold our list of bars
    bar_array = []

    #get all bar anchors
    links = page.links_with(text: 'Quiz Info')

    #follow each link and scrape bar data
    links.each do |link|

      begin
        bar = Bar.new
        page = mechanize.get(link.href)

        #get name
        name = page.at('h1').content
        bar.name = name

        #get day and time
        day_time = page.at('#ctl00_MainContent_lblQuizDayTime').content
        day = day_time.split(',')[0]
        time = day_time.split(',')[1].gsub('.','').gsub(' ','')
        bar.trivia_day = day
        bar.trivia_time = time

        #get  address
        address_block_string = page.at('.row').at('.cols2').content
        address_array = address_block_string.gsub("\t", '').gsub("\r",'').split("\n")

        address = address_array[2]
        city_state_zip = address_array[3]
        city = city_state_zip.split(',')[0]

        state_zip = city_state_zip.split(',')[1]
        state = state_zip.split(' ')[0]
        zip = state_zip.split(' ')[1]

        bar.city = city
        bar.state = state
        bar.zip = zip
        bar.address = address

        bar.trivia_type = 'brain'
        bar_array.push bar

      rescue
        Rails.logger.error 'Failed to parse a brain bar'
        next
      end
    end

    #populate bar lat and long, rate limited to 10 per second
    make_multiple_requests(bar_array) do |bar|
      bar.populateLocation
    end

    #return bar array
    return bar_array

  end

  def scrape_sporcle

    #get sporcle page
    mechanize = Mechanize.new
    page = mechanize.get('http://www.sporcle.com/live/locations/')

    #initialize array to hold our list of bars
    bar_array = []

    #because bars are listed more than once keep track of visited urls
    visited_urls = Set.new

    #get all state links
    state_links = page.search('#locations-states h3 a')

    # iterate over states
    state_links.each do |state|

      state_page = mechanize.get(state.attribute('href'))
      city_list = state_page.search('#locations-cities h3 a')

      #iterate over cities
      city_list.each do |city|

        city_page = mechanize.get(city.attribute('href'))
        bar_list = city_page.search('#locations-venues a')

        #iterate over bars
        bar_list.each do |bar_link|

          #see if bar has been visited before
          if visited_urls.include? bar_link.attribute('href').text
            next
          else
            visited_urls.add(bar_link.attribute('href').text)
          end

          bar_page = mechanize.get(bar_link.attribute('href'))



          full_day_time = bar_page.at('#venue-show-times').content
          day_time_split_by_pipe = full_day_time.split('|')

          #iterate over multiple days and times making an entry for each
          day_time_split_by_pipe.each do |day_time|
            bar = Bar.new
            day = day_time.split(',')[0].gsub("\t", '').gsub("\r",'').gsub("\n",'')
            day = day[0..-2] #chop off last character
            time = day_time.split(',')[1].gsub("\t", '').gsub("\r",'').gsub("\n",'')

            name = bar_page.at('#venue-text h1').content
            address = bar_page.at('#address-line-1').content

            city_state_zip = bar_page.at('#address-line-2').content
            city = city_state_zip.split(',')[0]
            state_zip =city_state_zip.split(',')[1]
            state = state_zip.split(' ')[0]
            zip = state_zip.split(' ')[1]

            bar.name = name
            bar.address = address
            bar.city = city
            bar.state = state
            bar.zip = zip
            bar.trivia_day = day
            bar.trivia_time = time
            bar.trivia_type = 'sporcle'

            bar_array.push(bar)
          end

        end
      end
    end

    #populate lat and lng
    make_multiple_requests(bar_array) do |bar|
      bar.populateLocation
    end
    
    #return
    return bar_array

  end


  private

  def make_multiple_requests(queue, &block)
    queue.each do |request|
      timer = Thread.new { sleep 0.1 }
      execution = Thread.new {yield(request) }
      [timer, execution].each(&:join)
    end
  end

end