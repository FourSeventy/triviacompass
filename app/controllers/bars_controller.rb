class BarsController < ApplicationController

  def index

    #pull all bars from DB for listing
    @all_bars = Bar.all().order(:name)

  end
end
