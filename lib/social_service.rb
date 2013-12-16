class SocialService < BaseService
  def follow(app, user_id, token)
    user_to_follow = users_repository.find_by_id(app, user_id)
    follow_data = {}
    follow_data['following'] = user_to_follow['_id']
    follow_data['_private'] = false
    resource_service.create(app, :follow, follow_data, token)
  end

  def get_followed_resources(app, resource_name, token)
    followed_users = resource_service.get_all_by_owner(app, :follow, token)
    followed_users = followed_users.reduce([]) { |memo, user| memo << user['following'] }
    query = {}
    query['_user_id'] = { "$in" => followed_users }
    resource_service.get_all(app, resource_name, token, query)
  end

  private

  def users_repository 
    UserMongoRepository.new
  end

  def resource_service
    ResourceService.new
  end
end