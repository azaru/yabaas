class Api::ResourcesController < Api::ApiController
  before_filter :auth_token
  before_action :set_resource_service

  def create
    user = @token_service.get_from_token(@app._id, request.headers['token'])
    result = @resource_service.create(@app._id, params[:resource], JSON.parse(request.raw_post), user["_id"])
    render json: result
  end

  private

  def set_resource_service
    @resource_service ||= ResourceMongoService.new
  end

end
