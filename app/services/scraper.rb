class Scraper

  #helper method that does all the logic for running a scraper
  #team, geeks, stump, brain, sporcle, trivianation
  def self.run(id)
    #build scraper service
    scraper_service = Scraper.new

    #scrape bars
    result = scraper_service.send('scrape_' + id)

    #todo: check for scrape errors
    Bar.transaction do
      Bar.where(trivia_type: id).delete_all

      #save all bars to the db
      result.each do |bar|
        bar.save
      end
    end

    #return json of bars
    Rails.logger.info result
  end

  # http://www.teamtrivia.com/
  def scrape_team

    #make get request to page
    mechanize = Mechanize.new
    page = mechanize.get('http://www.teamtrivia.com/search.asp?izipcode=&imiles=50&iday=blank&locationname=&locationregion=')

    #initialize array to hold our list of bars
    bar_array = []

    rows = page.search(".searchresults  tr:not(:first-child)")
    rows.each do |row|
      bar = Bar.new
      bar.trivia_type = 'team'
      bar.address = row.search("td:nth-child(1)").to_s.strip.split("<br>")[1]
      bar.name = row.search("td:nth-child(1) a").text.strip.gsub(/&amp;/, "&")
      if bar.name == "FOR CURRENT LISTINGS GO TO www.teamtriviami.com" 
        bar.name = bar.address
      end
      bar.city = row.search("td:nth-child(1)").to_s.strip.split("<br>")[2].split(",")[0]
      bar.state = row.search("td:nth-child(1)").to_s.strip.split("<br>")[2].split(",")[1].strip.gsub(/[[:space:]]/, " ").gsub("</td>", "").split(" ")[0]
      bar.zip = row.search("td:nth-child(1)").to_s.strip.split("<br>")[2].split(",")[1].strip.gsub(/[[:space:]]/, " ").gsub("</td>", "").split(" ")[1]
      bar.trivia_time = row.search("td:nth-child(2)").to_s.strip.split("<br>")[1]
      bar.trivia_day = row.search("td:nth-child(2)").to_s.strip.split("<br>")[0].split(">").last
      bar.phone = row.search("td:nth-child(3)").text.strip
      bar_array << bar
    end

    make_multiple_requests(bar_array) do |bar|
      print "."
      bar.populateLocation
    end

    return bar_array
  end

  # https://www.lastcalltrivia.com/schedule/
  def scrape_lastcall

    #make get request to page
    mechanize = Mechanize.new
    page = mechanize.get('https://www.lastcalltrivia.com/schedule/')

    #initialize array to hold our list of bars
    bar_array = []


    divs = page.search(".scheduleBox>div")
    divs.each do |div|
      bar = Bar.new
      bar.trivia_type = 'lastcall'
      bar.name = div.search(".showVenue").text.strip.gsub(/&amp;/, "&").humanize
      time_block = div.search(".timeDate b").text.split("|").first
      day = time_block.split(" ").first
      time = time_block.split(" ")[1..2].join(" ")

      day_map = {
        'SUN' => 'Sunday',
        'MON' => 'Monday',
        'TUE' => 'Tuesday',
        'WED' => 'Wednesday',
        'THU' => 'Thursday',
        'FRI' => 'Friday',
        'SAT' => 'Saturday',
      }

      bar.trivia_day = day_map[day]
      bar.trivia_time = time

      address_block = div.search(".showAddress").text.strip
      bar.address = address_block.strip.split(",").first.strip
      bar.city =  address_block.strip.split(",")[1].strip
      bar.state = address_block.strip.split(",").last.split("(").first.strip
      bar.phone = "(" + address_block.strip.split(",").last.split("(")[1]

      bar_array << bar
    end


    #populate lat and lng
    make_multiple_requests(bar_array) do |bar|
      bar.populateLocation
    end

    return bar_array
  end

  # https://www.geekswhodrink.com/schedule/MA
  def scrape_geeks

    url = 'https://dori-us-east-1.searchly.com/website/venue/_search?from=0&size=3000'
    raw_response = HTTP.headers({"Content-Type" => "application/x-www-form-urlencoded",
                                 "Authorization" =>"Basic d2Vic2l0ZTpxaGJnbDVsczJ1Zm12cjI1aHFwNGhtdGVyaWZhbnplNw=="})
      .get(url)

    #parse response to a hash
    response = JSON.parse raw_response.to_s

    #handle bad response
    if raw_response.code != 200
      Rails.logger.error('Error scraping geeks bars')
      Rails.logger.error(raw_response.reason)
    end

    #initialize array to hold our list of bars
    bar_array = []

    #iterate over all results
    response["hits"]["hits"].each do |row|
      bar_details = row["_source"]

      #skip bars if the data is bad
      if bar_details["status"] != "Active" || bar_details["location"].nil?
        next
      end

      #make a new bar for each quiz day
      bar_details["quizDays"].each do |day|
        bar = Bar.new
        bar.name = bar_details["venueName"].gsub /&amp;/, "&"
        bar.address = bar_details["address"]
        bar.city = bar_details["city"]
        bar.state = bar_details["state"]
        bar.zip = bar_details["zip"]
        bar.phone = bar_details["phone"]
        bar.trivia_day = day
        bar.lat = bar_details["location"][1]
        bar.long = bar_details["location"][0]
        bar.trivia_type = 'geeks'
        bar.trivia_time = (DateTime.parse(bar_details["quizStartDateTimeUTC"]) - 6.hours).strftime("%l:%M %P")

        bar_array << bar
      end
    end

    #return array of bars
    return bar_array
  end

  # https://www.stumptrivia.com/
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

    #make get request to brain page
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

  #TODO: fixme
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

  def scrape_trivianation

    #get page
    url = 'http://www.trivianation.com/wp-admin/admin-ajax.php'
    body = {'address' => '', 'game_type' => 1, 'action' =>'findashow'}
    mechanize = Mechanize.new
    page = mechanize.post(url, body)

    #initialize array to hold our list of bars
    bar_array = []

    #get all the bar entries
    bar_entries = page.search('li.location')

    bar_entries.each do |bar_block|

      name = bar_block.at('span.strong').content
      a_element = bar_block.at('a')

      address_span = a_element.next.next
      address = address_span.content

      city_state_zip_span = address_span.next.next
      city_state_zip = city_state_zip_span.content
      city = city_state_zip.split(',')[0]
      state_zip =city_state_zip.split(',')[1]
      state = state_zip.split(' ')[0]
      zip = state_zip.split(' ')[1]

      phone_span = city_state_zip_span.next.next
      phone = phone_span.content.gsub(/[^0-9]/, "")


      time_spans = bar_block.search('span.time')

      time_spans.each do |time_span|

        day_time = time_span.content
        day = day_time.split('-')[0]
        time = day_time.split(' ')[-2] + 'pm'

        bar = Bar.new
        bar.trivia_type = 'trivianation'
        bar.trivia_day = day
        bar.trivia_time = time
        bar.name = name
        bar.address = address
        bar.city = city
        bar.state = state
        bar.zip = zip
        bar.phone = phone

        bar_array.push bar
      end
    end

    #populate lat and lng
    make_multiple_requests(bar_array) do |bar|
      bar.populateLocation
    end

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
