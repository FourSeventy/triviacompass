Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  #root
  root 'home#index'

  #admin panel
  get 'admin' => 'admin#index'
  get 'admin/newBar' => 'admin#newBar'
  post 'admin/newBar' => 'admin#createBar'
  get 'admin/editBar/:id' => 'admin#editBar'
  post 'admin/editBar' => 'admin#updateBar'
  post 'admin/deleteBar' => 'admin#deleteBar'
  get 'admin/scrape' => 'admin#scrape'
  post 'admin/scrapeGeeks' => 'admin#scrape_geeks'
  post 'admin/scrapeStump' => 'admin#scrape_stump'
  post 'admin/scrapeBrain' => 'admin#scrape_brain'
  post 'admin/scrapeSporcle' => 'admin#scrape_sporcle'
  post 'admin/scrapetrivianation' => 'admin#scrape_trivianation'


  #rating api
  get 'ratings' => 'rating#index'
  get 'ratings/:id' => 'rating#show'
  post 'ratings' => 'rating#create'

  #bar api
  get 'bars' => 'bars#index'

end
