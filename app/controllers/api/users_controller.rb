class Api::UsersController < Api::ApiController
  before_filter :auth_token, only: [:profile]
  before_action :set_user_service
 

  def create
    new_user_to_create = request_to_json
    user = @users_service.create_user(@app._id, new_user_to_create)
    if user
      render json: prepare_user(user, @app._id)
    else
      render json: {} 
    end
  end

  def signin
    user_to_sigin = request_to_json
    user = @users_service.sign_in(@app._id, user_to_sigin)   
    render json: prepare_user(user, @app._id) 
  end

  def show
  end

  def profile
    user = @token_service.get_from_token(@app._id, request.headers['token'])
    render json: prepare_user(user, @app._id)
  end

  private

  def prepare_user user, app
    user['uri'] = api_get_user_path @app._id, user["_id"]
    user = remove_private_params user
    user.delete("password")
    user
  end
end