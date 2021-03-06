Yabaas::Application.routes.draw do

  devise_for :clients

  resources :clients, except: [:new] do
    resources :apps, shallow: true
  end

  namespace :api, defaults: {format: 'json'} do
    post ':app_id/users/login' => 'users#login' 
    post ':app_id/users' => 'users#create'

    post ':app_id/users/users' => 'api#denegate'
    post ':app_id/users/tokens' => 'api#denegate'

    post ':app_id/users/follow' => 'social#create_follow'

    post ':app_id/users/:resource' => 'resources#create', defaults: { _private: true } 
    post ':app_id/:resource' => 'resources#create', defaults: { _private: false }

    get ':app_id/users' => 'users#index'
    get ':app_id/users/:id' => 'users#show', as: :get_user

    get ':app_id/users/:user_id/users' => 'api#denegate'
    get ':app_id/users/:user_id/tokens' => 'api#denegate'

    get ':app_id/users/:user_id/:resource' => 'resources#index'

    get ':app_id/tokens' => 'api#denegate'
    get ':app_id/tokens/:id' => 'api#denegate'

    get ':app_id/follow/:resource' => 'social#index'

    get ':app_id/:resource' => 'resources#index'
    get ':app_id/:resource/:id' => 'resources#show', as: :get_resource

    delete ':app_id/users/logout' => 'users#logout'
# resources de un usuario
# resources para un collection de un usuario
 #   get ':app_id/following/:resource'
  end

end
