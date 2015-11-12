class HomeController < ApplicationController

  def index

    #get location
         #use cookied location
         #if not, use Boston as default
    @location = 'Boston, MA'

    #if we have a location, set proper header state

    #get bars by location
    radius = 10 #miles
    bars = Bar.get_bars_in_radius(42.3583827,	-71.0626648	, radius)

    #organize bars into hash by day
    @bars_by_day = Bar.sort_bars_into_days(bars)

  end
end
