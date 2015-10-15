require "http"


class Bar < ActiveRecord::Base


  validates :name, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  validates_format_of :zip, with: /\A\d{5}(-\d{4})?\z/, message: "should be in the form 12345 or 12345-1234"
  validates :phone, presence: true, numericality: {only_integer: true}
  validates_format_of :phone, with: /\d{10}/, message: "must be ten digits"
  validates :trivia_day, presence: true
  validates :trivia_time, presence: true
  validates :lat, presence: true
  validates :long, presence: true



  def self.getBarsByDay

    #pull all bars from DB for listing ordered by trivia_day
    all_bars = Bar.all().order(:trivia_day)

    #divide out bars based on trivia day
    day_hash = {sunday: [], monday: [], tuesday: [], wednesday: [], thursday: [], friday: [], saturday: []}

    #marshal out bars
    all_bars.each do |bar|

      case bar.trivia_day

        when 'Sunday' then day_hash[:sunday].push bar
        when 'Monday' then day_hash[:monday].push bar
        when 'Tuesday' then day_hash[:tuesday].push bar
        when 'Wednesday' then day_hash[:wednesday].push bar
        when 'Thursday' then day_hash[:thursday].push bar
        when 'Friday' then day_hash[:friday].push bar
        when 'Saturday' then day_hash[:saturday].push bar
        else

      end
    end

    #sort each day by time
    day_hash.each do |day, bars|
      bars.sort! do |a, b|
        a.trivia_time <=> b.trivia_time
      end
    end

    return day_hash

  end


  def populateLocation

    #define parts of request
    endpoint ='https://maps.googleapis.com/maps/api/geocode/json'
    key = Rails.configuration.google_maps_api_key
    address_param= CGI.escape("#{self.address} #{self.city} #{self.state} #{self.zip}")

    #send HTTP request
    raw_response = HTTP.get("#{endpoint}?key=#{key}&address=#{address_param}")

    #parse response to json
    response = JSON.parse raw_response.to_s

    #raise exception if response isn't ok
    raise 'No Results' if response['status'] != 'OK'

    #set lat and long from response
    location = response['results'][0]['geometry']['location']
    self.lat = location['lat']
    self.long = location['lng']

    return

  end


end
