class HomeController < ApplicationController

  def index

    #get location
         #use cookied location
         #if not, use Boston as default
    default_location = {name: 'Boston, MA', lat: 42.3583827, lng: -71.0626648 }

    #if we have a location, set proper header state

    #get bars by location
    radius = 10 #miles
    bars = Bar.get_bars_in_radius(default_location[:lat],	default_location[:lng], radius)

    #organize bars into hash by day
    bars_by_day = Bar.sort_bars_into_days(bars)

    #assign default data to page
    @default_data = {location: default_location, bars: bars_by_day}

  end
end
