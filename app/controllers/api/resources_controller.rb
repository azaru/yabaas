class Api::ResourcesController < Api::ApiController
  before_filter :auth_token
  before_action :set_resource_service

  def create
    resource = request_to_json
    resource['_private'] = params['_private']
    resource_name = request.path_parameters[:resource]
    token = request.headers['token']

    result = @resource_service.create(@app._id, resource_name, resource, token)

    render json: prepare_resource(result)
  end

  def show
    resource_name = request.path_parameters[:resource]
    resource_id = request.path_parameters[:id]

    resource = @resource_service.get(@app._id, resource_name, resource_id)

    render json: prepare_resource(resource)
  end

  def index
    resource = request.path_parameters[:resource]
    token = request.headers['token']
    query = prepare_query
    resources = @resource_service.get_all(@app._id, resource, token, query)
    render json: resources.reduce([]) { |memo, resource| memo << prepare_resource(resource) }
  end

  private

  def prepare_query
    query = {}
    if params.has_key?(:query)
      query = JSON.parse(params['query'])
    end
    if request.path_parameters.has_key?(:user_id) 
        if BSON::ObjectId.legal?(request.path_parameters[:user_id])
          query['_user_id'] = BSON::ObjectId.from_string(request.path_parameters[:user_id])
        else
          query['_user_id'] = BSON::ObjectId.new
        end
    end
    query
  end

  def prepare_resource resource
    resource['url'] = api_get_resource_path @app._id, request.path_parameters[:resource], resource['_id']
    resource = remove_private_params resource
  end

  def set_resource_service
    @resource_service ||= ResourceService.new
  end
end
