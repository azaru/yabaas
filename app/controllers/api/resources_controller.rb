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
    resources = @resource_service.get_all(@app._id, resource, token)
    render json: resources
  end

  private

  def prepare_resource resource
    resource['url'] = api_get_resource_path @app._id, request.path_parameters[:resource], resource['_id']
    # eliminar la metainformacion en servicio (es parte de la logica y puede cambiarse)
    resource = remove_private_params resource
  end

  def set_resource_service
    @resource_service ||= ResourceService.new
  end
end
