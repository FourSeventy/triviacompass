class Bar < ActiveRecord::Base
  validates :name, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  validates_format_of :zip, with: /\A\d{5}(-\d{4})?\z/, message: "should be in the form 12345 or 12345-1234"
  #validates :phone, numericality: {only_integer: true}, :allow_nil => true
  #validates_format_of :phone, with: /\d{10}/, message: "must be ten digits"
  validates :trivia_day, presence: true
  validates :trivia_time, presence: true
  validates :lat, presence: true
  validates :long, presence: true


  def self.get_bars_in_radius(lat, long, radius)
    #pull all bars from DB
    all_bars = Bar.all()

    #if our params are nil return full list
    if lat == nil or long == nil or radius == nil
      return all_bars
    end

    filtered_list = []
    all_bars.each() do |bar|
      #get distance to bar
      dist = Haversine.distance(bar.lat.to_f, bar.long.to_f, lat, long).to_miles

      #add to list if we are within radius
      if dist <= radius
        filtered_list.push bar
      end
    end

    return filtered_list
  end


  def self.sort_bars_into_days(all_bars)
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
          raise "invalid trivia_day"
      end
    end

    #sort each day by time
    day_hash.each do |day, bars|
      bars.sort! do |a, b|
        Time.parse(a.trivia_time) <=> Time.parse(b.trivia_time)
      end
    end

    return day_hash
  end


  def populateLocation
    #define parts of request
    endpoint ='https://maps.googleapis.com/maps/api/geocode/json'
    key = Rails.configuration.google_maps_key
    address_param= CGI.escape("#{self.address} #{self.city} #{self.state} #{self.zip}")

    #send HTTP request
    raw_response = HTTP.get("#{endpoint}?key=#{key}&address=#{address_param}")

    #parse response to json
    response = JSON.parse raw_response.to_s

    #raise exception if response isn't ok
    raise 'No Results from geocode api'if response['status'] != 'OK'

    #set lat and long from response
    location = response['results'][0]['geometry']['location']
    self.lat = location['lat']
    self.long = location['lng']

    return
  end

end
