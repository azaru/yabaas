class Api::ResourcesController < Api::ApiController
  before_filter :auth_token
  before_action :set_resource_service
  before_action :set_user

  def create
    resource = request_to_json
    resource['_private'] = params['_private']
    user = @token_service.get_from_token(@app._id, request.headers['token'])
    result = @resource_service.create(@app._id, request.path_parameters[:resource], resource, user["_id"])
    render json: prepare_resource(result)
  end

  def show
    resource = @resource_service.get(@app._id, request.path_parameters[:resource],request.path_parameters[:id])
    render json: prepare_resource(resource)
  end

  def index
    resources = @resource_service.get_all(@app._id, request.path_parameters[:resource])
    render json: resources.reduce([]) { |memo, resource| 
      if resource['_private'] == false || resource['_user_id'].to_s == @user['_id'].to_s
       memo << resource['_id'].to_s 
      end
    }
  end

  private

  def prepare_resource resource
    resource['uri'] = api_get_resource_path @app._id, request.path_parameters[:resource], resource['_id']
    resource = remove_private_params resource
  end

  def set_resource_service
    @resource_service ||= ResourceMongoService.new
  end

  def set_user
    @user = @token_service.get_from_token(@app._id, request.headers['token'])
  end
end
