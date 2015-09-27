class BarsController < ApplicationController

  def index

    #pull all bars from DB for listing ordered by trivia_day
    all_bars = Bar.all().order(:trivia_day)

    #divide out bars based on trivia day
    @monday_bars = []
    @tuesday_bars = []
    @wednesday_bars = []
    @thursday_bars = []
    @friday_bars = []
    @saturday_bars = []
    @sunday_bars = []

    all_bars.each do |bar|

      case bar.trivia_day

        when 'Monday' then @monday_bars.push bar
        when 'Tuesday' then @tuesday_bars.push bar
        when 'Wednesday' then @wednesday_bars.push bar
        when 'Thursday' then @thursday_bars.push bar
        when 'Friday' then @friday_bars.push bar
        when 'Saturday' then @saturday_bars.push bar
        when 'Sunday' then @sunday_bars.push bar

      end
    end



  end
end
