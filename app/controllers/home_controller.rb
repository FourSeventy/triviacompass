class HomeController < ApplicationController

  def index
    #set default location
    location = {name: 'Boston, MA', lat: 42.3583827, lng: -71.0626648 }
    #set search options
    options = {radius: 30} #miles

    #override location if cookied location exists
    cookie_location = cookies[:location]
    unless cookie_location.nil?
      location = JSON.parse(cookie_location, {:symbolize_names => true})
      @cookied = true;
    end

    #get bars by location
    bars = Bar.get_bars_in_radius(location[:lat],	location[:lng], options[:radius])

    #organize bars into hash by day
    bars_by_day = Bar.sort_bars_into_days(bars)

    #write default data to page
    @default_data = {location: location, options: options, bars: bars_by_day}
  end
end
