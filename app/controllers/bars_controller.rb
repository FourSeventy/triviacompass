class BarsController < ApplicationController

  #GET /bars
  def index
    #get lat and long query params
    lat = params[:lat]
    long = params[:long]
    radius = params[:radius]

    #get bars from DB
    bars = Bar.get_bars_in_radius(lat.to_f, long.to_f, radius.to_f)

    #sort bars into day hash
    bars_by_day = Bar.sort_bars_into_days(bars)

    #return the hash as json
    render json: bars_by_day
  end

  #GET /bars/:id
  def show
    bar = Bar.find(params[:id])

    render json: bar
  end
end
