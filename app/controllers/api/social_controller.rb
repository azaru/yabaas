class Api::SocialController < Api::ApiController
  before_filter :auth_token
  before_action :set_social_service
  
  def create_follow
    parsed_request = request_to_json
    result = @social_service.follow(@app._id, parsed_request['user_id'], request.headers['token'])
    if result
      render :nothing => true, status: :ok
    else
      render :nothing => true, status: :bad_request
    end
  end

  def index
    token = request.headers['token']
    resource_name = request.path_parameters[:resource]
    resources = @social_service.get_followed_resources(@app._id, resource_name, token)
    render json: resources.reduce([]) { |memo, resource| memo << prepare_resource(resource) }
  end
end