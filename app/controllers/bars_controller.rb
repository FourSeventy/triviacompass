class BarsController < ApplicationController

  def index

    @bars_by_day = Bar.getBarsByDay

  end
end
