class HomeController < ApplicationController

  def index

    today = Date.today.strftime('%A')
    @tonights_bars = Bar.where(trivia_day: today).order(:trivia_time)

  end
end
