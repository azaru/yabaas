class Api::Socialcontroller < Api::ApiController
  before_filter :auth_token
  
  def create_follow
    result = @user_service.follow(app._id, params['user_id'], request.headers['token'])
    if result
      render :nothing => true, status: :ok
    else
      render :nothing => true, status: :bad_request
    end
  end
end