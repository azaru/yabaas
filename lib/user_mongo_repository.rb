class UserMongoRepository < BaseMongoRepository

  def insert(app, user)
    database(app,:users).insert(user)
  end

  def exists_user_with_email(app, email)
    number_of_users = database(app,:users).find(email: email).count
    number_of_users != 0
  end

  def find_user(app, email)
    database(app, :users).find(email: email).one
  end

  def find_by_id(app, id, one=true)
    id = BSON::ObjectId.from_string(id) if id.instance_of?(String)
    result = database(app, :users).find( { _id: id })
    one ? result.one : result
  end

  def get_all app, query
    database(app, :users).find(query)
  end
end