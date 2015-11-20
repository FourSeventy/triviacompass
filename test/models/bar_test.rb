require 'test_helper'

class BarTest < ActiveSupport::TestCase

  test "field validation" do

    bar = Bar.new(name: "Doyles", address: "3484 Washington St", city: "Jamacia Plain", state: "MA", zip: "02130",
                  phone: nil, trivia_time: "7:00pm", trivia_day: "Monday", lat: "1", long: "2")
    assert bar.valid?, "Bar validator failure"

    bar = Bar.new(name: "Doyles", address: "3484 Washington St", city: "Jamacia Plain", state: "MA", zip: "02130",
                  phone: "5085421111", trivia_time: "7:00pm", trivia_day: "Monday", lat: "1", long: "2")
    assert bar.valid?, "Bar validator failure"

    bar = Bar.new(name: "Doyles", address: "3484 Washington St", city: "Jamacia Plain", state: "MA", zip: "02130-1234",
                  phone: "5085421111", trivia_time: "7:00pm", trivia_day: "Monday", lat: "1", long: "2")
    assert bar.valid?, "Bar validator failure"
  end

end
