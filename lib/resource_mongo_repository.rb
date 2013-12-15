class ResourceMongoRepository  < BaseMongoRepository
  def create app, resource_name, resouce_data
   database(app, resource_name).insert(resouce_data)
  end

  def get app, resource_name, resource_id
    database(app, resource_name).find(_id: BSON::ObjectId.from_string(resource_id)).one
  end

  def get_all app, resource_name, query
    database(app, resource_name).find(query)
  end
end