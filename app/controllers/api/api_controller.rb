class Api::ApiController < ApplicationController
  protect_from_forgery with: :null_session
  before_filter :set_app_if_exist

  private
  def set_token_service
    @token_service ||= TokenMongoService.new
  end

  def request_to_json
    JSON.parse(request.raw_post)
  end

  def set_user_service
     @users_service ||= UsersService.new
  end

  def set_application_repository
     @application_repository ||= ApplicationMongoRepository.new
  end

  def set_app_if_exist
    @app = set_application_repository.by_id(params[:app_id])
    render :nothing => true, :status => :bad_request if @app == nil
  end

  def auth_token
    set_token_service
    token_exist = @token_service.token_exist?(@app._id, request.headers["token"])
    render :nothing => true, :status => :unauthorized unless token_exist  
  end
  
  def remove_private_params hash_object
    hash_object.reject {|key, value| key[0,1] == '_' }
  end
end