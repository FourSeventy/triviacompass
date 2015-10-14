class RatingController < ApplicationController

  #GET ratings
  def list

    all_ratings = Rating.all

  end

  #GET ratings/:id
  def get

    #get all ratings for given id
    ratings = Rating.where(:bar_id => params[:id])

    #calculate average rating
    total = 0.0
    ratings.each do |entry|
      total += entry.rating
    end
    total = total / ratings.size

    #return as json
    render :json => total

  end

  #POST ratings
  def createRating

    Rating.create(bar_id: 1, rating: 4, ip: '192.168.0.1')

    render :nothing => true
  end

end
