class ResourceMongoRepository  < BaseMongoRepository
  def create app, resource_name, resouce_data
    database(app, resource_name).insert(resouce_data)
  end
end