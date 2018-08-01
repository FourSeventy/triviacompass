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

  #bar api
  get 'bars' => 'bars#index'
end
