class ResourceService < BaseService

  def create app, resource_name, resource_data, token
    user = @token_service.get_from_token(@app._id, token)
    resource_data['_user_id'] = user['_id']
    resource_data['_id'] = BSON::ObjectId.new
    resource_repository.create(app, resource_name, resource_data)
    resource_data
  end 

  def get app, resource_name, resource_id
    resource_repository.get app, resource_name, resource_id
  end

  def get_all app, resource_name
    resources = resource_repository.get_all app, resource_name
    resources = resources.reduce([]) { |memo, resource| 
      if resource['_private'] == false || resource['_user_id'].to_s == @user['_id'].to_s
       memo << resource['_id'].to_s 
      end
    }
    resources
  end

  private
  
  def resource_repository
    ResourceMongoRepository.new
  end

  def users_repository 
    UserMongoRepository.new
  end
end