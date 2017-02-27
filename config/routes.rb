Rails.application.routes.draw do
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

  #bar api
  get 'bars' => 'bars#index'
end
