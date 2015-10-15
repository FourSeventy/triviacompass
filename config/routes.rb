Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  #root
  root 'home#index'

  #bars listing
  get 'bars' => 'bars#index'

  #admin panel
  get 'admin' => 'admin#index'
  get 'admin/newBar' => 'admin#newBar'
  post 'admin/newBar' => 'admin#createBar'
  get 'admin/editBar/:id' => 'admin#editBar'
  post 'admin/editBar' => 'admin#updateBar'
  post 'admin/deleteBar' => 'admin#deleteBar'

  #map page
  get 'map' => 'map#index'

  #rating api
  get 'ratings' => 'rating#list'
  get 'ratings/:id' => 'rating#get'
  post 'ratings' => 'rating#new'






  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
