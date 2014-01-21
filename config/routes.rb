EDEC::Application.routes.draw do
  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  get 'groups/created' => 'groups#created'
  get 'groups/joined' => 'groups#joined'
  get 'groups/:name/search' => 'groups#search'
  get 'groups/:id/join' => 'groups#join'
  get 'groups/:id/leave' => 'groups#leave'
  get 'groups/trending' => 'groups#trending'
  get 'groups/suggest/personal' => 'groups#personal_suggestions'
  get 'groups/suggest/friends' => 'groups#friends_suggestion'

  get 'products/:id/similar' => 'products#similar'
  get 'products/:id/verdict' => 'products#verdict'

  get '/stats/top/ingredients' => 'stats#ingredients'
  get '/stats/top/products' => 'stats#products'
  get '/stats/top/companies' => 'stats#companies'

  get 'products/:name/search' => 'products#search'
  get 'ingredients/:name/search' => 'ingredients#search'
  get 'companies/:name/search' => 'companies#search'

  resources :products
  resources :ingredients
  resources :companies
  resources :filter_reasons
  resources :groups

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
