class ApplicationMongoRepository < BaseMongoRepository

  def by_id(id)
    App.find(id)
  end
end