class ResourceService < BaseService

  def create app, resource_name, resource_data, token
    user = token_service.get_from_token(app, token)
    resource_data['_user_id'] = user['_id']
    resource_data['_id'] = BSON::ObjectId.new
    resource_data['created_at'] = Time::now.to_i
    resource_repository.create(app, resource_name, resource_data)
    resource_data
  end 

  def get app, resource_name, resource_id
    resource_repository.get app, resource_name, resource_id
  end

  def get_all app, resource_name, token, query = {}
    resources = resource_repository.get_all app, resource_name, query
    user = token_service.get_from_token(app, token)

    resources = resources.reduce([]) { |memo, resource| 

      if resource['_private'] == false || resource['_user_id'].to_s == user['_id'].to_s
        memo << resource
      else
        memo = memo
      end
    }
    resources || []
  end

  def get_all_by_owner app, resource_name, token
    user = token_service.get_from_token(app, token)
    query = {}
    query['_user_id'] = user['_id']
    resource_repository.get_all(app, resource_name, query).entries
  end

  private
  def token_service
    TokenService.new
  end
  
  def resource_repository
    ResourceMongoRepository.new
  end

  def users_repository 
    UserMongoRepository.new
  end
end