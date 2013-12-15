class Api::UsersController < Api::ApiController
  before_filter :auth_token, only: [:profile, :logout]
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

  def logout
    @token_service.delete(@app._id, request.headers['token'])
    render :nothing => true, :status => :ok
  end

  def login
    user_to_login = request_to_json
    user = @users_service.sign_in(@app._id, user_to_login)   
    render json: prepare_user(user, @app._id) 
  end

  def show
    render :nothing => true, :status => :ok
  end

  def index
    query =  params.has_key?('query') ? JSON.parse(params['query']) : {}
    users = @users_service.get_all(@app._id, query)
    render json: users.reduce([]) {|memo, user| memo << user['_id'] }
  end

  private

  def prepare_user user, app
    user['url'] = api_get_user_path @app._id, user["_id"]
    user = remove_private_params user
    user.delete("password")
    user
  end
end