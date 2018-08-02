class AdminController < ApplicationController

  http_basic_authenticate_with :name => 'admin', :password => 'skywalker'

  #GET /admin
  def index
    #pull all bars from DB for listing
    @all_bars = Bar.all
  end


  #Get admin/newBar
  def newBar

  end


  #POST admin/newBar
  def createBar
    #gather params
    name = params[:name].strip
    address = params[:address].strip
    city = params[:city].strip
    state = params[:state].strip
    zip = params[:zip].strip
    phone = params[:phone].tr('()-', '') #remove ( ) and -
    trivia_time = params[:time].strip
    trivia_day = params[:day]
    trivia_type = params[:trivia_type]

    #create model
    bar = Bar.new(name: name, address: address, city: city, state: state, zip: zip, phone: phone, trivia_time: trivia_time, trivia_day: trivia_day, trivia_type: trivia_type)

    begin
      #populate location from google api
      bar.populateLocation
    rescue
      Rails.logger.error "Error populating bar location for #{name} #{address}"
    end

    #save to db
    bar.save

    #redirect to index if bar is valid
    if bar.valid? then
       redirect_to action: 'index'
    else

      #write form inputs to flash
      flash[:name] = name
      flash[:address] = address
      flash[:city] = city
      flash[:state] = state
      flash[:zip] = zip
      flash[:phone] = phone
      flash[:trivia_time] = trivia_time
      flash[:trivia_day] = trivia_day
      flash[:trivia_type] = trivia_type

      #write errors to flash
      flash[:errors] = bar.errors

      redirect_to action: 'newBar'
    end
  end

  #GET admin/editBar/:id
  def editBar
    #get bar id from params
    bar_id = params[:id]

    #get bar from id
    @bar = Bar.find bar_id
  end

  #POST admin/editBar
  def updateBar
    #gather params
    id = params[:id]
    name = params[:name].strip
    address = params[:address].strip
    city = params[:city].strip
    state = params[:state].strip
    zip = params[:zip].strip
    phone = params[:phone].tr('()-', '') #remove ( ) and -
    trivia_time = params[:time].strip
    trivia_day = params[:day]
    trivia_type = params[:trivia_type]

    #find record and update
    bar = Bar.find id
    bar.assign_attributes(name: name, address: address, city: city, state: state, zip: zip, phone: phone, trivia_time: trivia_time, trivia_day: trivia_day, trivia_type: trivia_type)

    begin
      #populate location from google api
      bar.populateLocation
    rescue

      Rails.logger.error "Error populating bar location for #{name} #{address}"

    end

    #save to db
    bar.save

    #redirect to index if bar is valid
    if bar.valid? then
      redirect_to action: 'index'
    else

      #write errors to flash
      flash[:errors] = bar.errors

      redirect_to action: 'editBar', id: id
    end
  end


  #POST admin/deletebar
  def deleteBar
    id = params[:id]

    bar = Bar.find(id)
    bar.destroy

    redirect_to action: 'index'
  end


  private


end
