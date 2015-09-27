class AdminController < ApplicationController

  #GET admin
  def index
    #pull all bars from DB for listing
    @all_bars = Bar.all().order(:id)
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
    phone = params[:phone]
    trivia_time = params[:time]
    trivia_day = params[:day]

    #create model and DB entry
    Bar.create(name: name, address: address, city: city, state: state, zip: zip, phone: phone, trivia_time: trivia_time, trivia_day: trivia_day)

    #redirect to index
    redirect_to action: 'index'

  end

  #GET admin/editBar/:id
  def editBar

    #get bar id from params
    bar_id = params[:id]

    #get bar from id
    @bar = Bar.find_by_id bar_id

  end

  #POST admin/editBar
  def updateBar

    #gather params
    id = params[:id]
    name = params[:name]
    address = params[:address]
    city = params[:city]
    state = params[:state]
    zip = params[:zip]
    phone = params[:phone]
    trivia_time = params[:time]
    trivia_day = params[:day]

    #find record and update
    bar = Bar.find_by_id(id)
    bar.update(name: name, address: address, city: city, state: state, zip: zip, phone: phone, trivia_time: trivia_time, trivia_day: trivia_day)

    #redirect to index
    redirect_to action: 'index'

  end

end
