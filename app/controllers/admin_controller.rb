class AdminController < ApplicationController

  def index
    #pull all bars from DB for listing
    @all_bars = Bar.all()
  end

  #Get admin/newBar
  def newBar

  end

  #POST admin/newBar
  def createBar

    #gather params
    name = params[:name]
    address = params[:address]
    city = params[:city]
    state = params[:state]
    zip = params[:zip]
    trivia_time = params[:time]
    trivia_day = params[:day]

    #create model and DB entry
    Bar.create(name: name, address: address, city: city, state: state, zip: zip, trivia_time: trivia_time, trivia_day: trivia_day)

    #redirect to index
    redirect_to action: 'index'

  end

end
