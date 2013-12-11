class ResourceMongoService < BaseService

  def create app, resource_name, resource_data, user_id
    resource_data['_user_id'] = user_id
    resource_data['_id'] = BSON::ObjectId.new
    resouce_repository.create(app, resource_name, resource_data)
    resource_data
  end 

  private
  
  def resouce_repository
    ResourceMongoRepository.new
  end

  def users_repository 
    UserMongoRepository.new
  end
end