class HomeController < ApplicationController

  def index

    #set default location
    location = {name: 'Boston, MA', lat: 42.3583827, lng: -71.0626648 }

    #override it if cookied location exists
    cookie_location = cookies[:location]
    unless cookie_location.nil?
      location = JSON.parse cookie_location
    end

    #get bars by location
    radius = 30 #miles
    bars = Bar.get_bars_in_radius(location[:lat],	location[:lng], radius)

    #organize bars into hash by day
    bars_by_day = Bar.sort_bars_into_days(bars)

    #assign default data to page
    @default_data = {location: location, bars: bars_by_day}

  end
end
