class Rating < ActiveRecord::Base

  validates :rating, presence: true
  validates_inclusion_of :rating, in: 1..10
  validates :bar_id, presence: true
  validates :ip, presence: true


  def self.getAllRatings

    #pull all ratings from the db
    all_ratings = Rating.all

    #break ratings into hash of bar_id => [sum,number]
    bar_hash = {}

    all_ratings.each do |rating|

      if bar_hash.has_key? rating.bar_id
        arr = bar_hash[rating.bar_id]
        arr[0] = arr[0] + rating.rating
        arr[1] += 1
      else
        bar_hash[rating.bar_id] = [rating.rating, 1]
      end

    end

    #iterate bar_hash sum the ratings and add them to final_rating_hash
    final_rating_hash = {}
    bar_hash.each do |k,v|

      final_rating_hash[k] = (v[0].to_f / v[1])
    end

    return final_rating_hash

  end


  def self.getRating(id)

    #get all ratings for given id
    ratings = Rating.where(bar_id: id)

    #calculate average rating
    total = 0.0
    ratings.each do |entry|
      total += entry.rating
    end

    total = total / ratings.size

    return total
  end



end
