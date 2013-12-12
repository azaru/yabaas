Yabaas::Application.routes.draw do

  devise_for :clients

  resources :clients, except: [:new] do
    resources :apps, shallow: true
  end
# , defaults: {format: 'json'}
  namespace :api, defaults: {format: 'json'} do
    post ':app_id/user/login' => 'users#login'
    delete ':app_id/user/logout' => 'users#logout'
    post ':app_id/user' => 'users#create'
    get ':app_id/user' => 'users#index'
    get ':app_id/user/profile' => 'users#profile', as: :get_profile
    get ':app_id/user/:id' => 'users#show', as: :get_user
    get ':app_id/:resource' => 'resources#index'
    post ':app_id/:resource' => 'resources#create'
    get ':app_id/:resource/:id' => 'resources#show'
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
