class MapController < ApplicationController


  def index

    #get list of bars for client
    @bars = Bar.all

  end
end
