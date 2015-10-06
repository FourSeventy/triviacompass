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




  def populateLocation

    endpoint ='https://maps.googleapis.com/maps/api/geocode/json'
    key = Rails.configuration.google_maps_api_key
    address_param= CGI.escape("#{self.address} #{self.city} #{self.state} #{self.zip}")

    raw_response = HTTP.get("#{endpoint}?key=#{key}&address=#{address_param}")

    #TODO: check for errors
    response = JSON.parse raw_response.to_s
    location = response['results'][0]['geometry']['location']

    self.lat = location['lat']
    self.long = location['lng']

  end


end
