class UsersService < BaseService
  
  def create_user(app, new_user)
  
    application = applicaton_repository.by_id(app)
    result = false
    unless users_repository.exists_user_with_email(application._id, new_user["email"]) 
      users_repository.insert(application._id, new_user) 
      result = users_repository.find_user(application._id, new_user["email"])
    end

    #TODO : Devolver errores 
    # asegurarse que  venga el email  y el password, guardar el password encriptado
    result
  end

  def sign_in(app, user)
    application = applicaton_repository.by_id(app)
    
    return false if application == nil

    user_in_db = users_repository.find_user(application._id, user["email"])

    if (user_in_db && user["email"] == user_in_db['email'] && user["password"] == user_in_db['password'])
      user_in_db["token"] = token_repository.new_token(app, user_in_db)
      user_in_db
    else
      false
    end
  end

  def sign_out(app, token)
    token_repository.delete_token(app, token)
  end

  def get_all(app)
    users_repository.get_all app
  end

  private

  def applicaton_repository 
    ApplicationMongoRepository.new
  end

  def users_repository 
    UserMongoRepository.new
  end

  def token_repository
    TokenMongoRepository.new
  end

end
