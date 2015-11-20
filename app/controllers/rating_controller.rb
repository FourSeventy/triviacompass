class RatingController < ApplicationController

  #GET /ratings
  def index

    ratings = Rating.get_all_ratings

    #return the hash as json
    render :json => ratings

  end


  #GET /ratings/:id
  def show

    rating = Rating.get_rating(params[:id])

    #return as json
    render :json => rating

  end


  #POST ratings
  def create

    #determine params
    ip = request.ip
    rating = params[:rating]
    bar_id = params[:bar_id]

    #find rating and update it, or create
    db_entry = Rating.where(ip: ip).first_or_create(bar_id: bar_id, rating: rating, ip: ip)
    db_entry.update(rating: rating)

    #log an error if our entry wasn't valid
    unless db_entry.valid?
      logger.error "Error saving rating for bar_id: #{bar_id} and ip: #{ip}"
    end

    render :nothing => true
  end

end
