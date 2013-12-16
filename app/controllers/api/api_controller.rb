class Api::ApiController < ApplicationController
  protect_from_forgery with: :null_session
  before_filter :set_app_if_exist

  def denegate
    render :nothing => true, :status => :bad_request
  end

  private
  def set_token_service
    @token_service ||= TokenService.new
  end

  def auth_token
    set_token_service
    token_exist = @token_service.token_exist?(@app._id, request.headers["token"])
    render :nothing => true, :status => :unauthorized unless token_exist  
  end


  def request_to_json
    sanitize_input JSON.parse(request.raw_post)
  end


  def set_user_service
     @users_service ||= UsersService.new
  end

  def set_application_service
     @application_service ||= ApplicationService.new
  end

  def set_app_if_exist
    @app = set_application_service.by_id(request.path_parameters[:app_id])
    render :nothing => true, :status => :bad_request if @app == nil
  end

  def sanitize_input hash_object
    hash_object.reject {|key, value| key[0,1] == '_' && key != '_private' }
  end
  
  def remove_private_params hash_object
    hash_object.reject {|key, value| key[0,1] == '_' }
  end

  def prepare_resource resource
    resource['url'] = api_get_resource_path @app._id, request.path_parameters[:resource], resource['_id']
    resource = remove_private_params resource
  end

  def set_resource_service
    @resource_service ||= ResourceService.new
  end

  def set_social_service
    @social_service ||= SocialService.new
  end
end