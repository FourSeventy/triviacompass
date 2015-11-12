class BarsController < ApplicationController

  #GET bars
  def list

    #get all bars from DB
    bars = Bar.all

    #sort bars into day hash
    bars_by_day = Bar.sort_bars_into_days(bars)

    #return the hash as json
    render :json => bars_by_day

  end
end
