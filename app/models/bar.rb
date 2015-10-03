class Bar < ActiveRecord::Base


  validates :name, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  validates_format_of :zip, with: /\A\d{5}(-\d{4})?\z/, message: "should be in the form 12345 or 12345-1234"
  validates :phone, presence: true, numericality: {only_integer: true}
  validates_format_of :phone, with: /\d{10}/, message: "must be ten digits"
  validates :trivia_day, presence: true
  validates :trivia_time, presence: true


end
