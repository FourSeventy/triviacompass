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
