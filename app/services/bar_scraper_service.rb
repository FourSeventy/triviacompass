require 'mechanize'

class BarScraperService

  def initialize()

  end

  ## Scrape the Geeks Who Drink bar listing page for bar data
  def scrape_geeks()

    #make get reqest to geeks page
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

      #find previous h1 for the day
      bar.trivia_day = result.at_xpath('(preceding-sibling::h1 | preceding-sibling::*//h1)[last()]').text

      #find time
      span =  result.at_xpath('following-sibling::span')
      bar.trivia_time = span.at_xpath('following-sibling::text()').text

      #add bar to array
      bar_array.push bar
    end


    #populate bar lat and long, rate limited to 10 per second
    make_multiple_requests(bar_array) do |bar|
      bar.populateLocation
    end

    #save all bars to the db
    bar_array.each do |bar|
      bar.save

      Rails.logger.error bar.errors.messages
    end

    return bar_array

  end


  def scrape_stump()

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