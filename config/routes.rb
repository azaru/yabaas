Yabaas::Application.routes.draw do

  devise_for :clients

  resources :clients, except: [:new] do
    resources :apps, shallow: true
  end

  namespace :api, defaults: {format: 'json'} do
    post ':app_id/users/login' => 'users#login' 
    post ':app_id/users' => 'users#create'

  #  post ':app_id/users/user' => 'api#denegate'
  #  post ':app_id/users/token' => 'api#denegate'

    post ':app_id/users/:resource' => 'resources#create', defaults: { _private: true } 
    post ':app_id/:resource' => 'resources#create', defaults: { _private: false }

    post ':app_id/friendships' => 'social#create_follow'


    get ':app_id/users' => 'users#index'
#    get ':app_id/users/profile' => 'users#profile', as: :get_profile
    get ':app_id/users/:id' => 'users#show', as: :get_user

  #  get ':app_id/tokens' => 'api#denegate'
  #  get ':app_id/tokens/:id' => 'api#denegate'

    get ':app_id/:resource' => 'resources#index'
    get ':app_id/:resource/:id' => 'resources#show', as: :get_resource

    delete ':app_id/users/logout' => 'users#logout'
  end

end
