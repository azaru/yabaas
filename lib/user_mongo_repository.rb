class UserMongoRepository < BaseMongoRepository

  def insert(app, user)
    database(app,:users).insert(user)
  end

  def exists_user_with_email(email, app)
    number_of_users = database(app,:users).find(email: email).count
    number_of_users != 0
  end

  def find_user(email, app)
    database(app, :users).find(email: email).one
  end

  def find_by_id(app, id)
    database(app, :users).find( { _id: id }).one
  end

  def get_all app
    database(app, :users).find()
  end
end