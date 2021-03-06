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
    user_in_db = users_repository.find_user(app, user["email"])

    if (user_in_db && user["password"] == user_in_db['password'])
      user_in_db["token"] = token_repository.new_token(app, user_in_db)
      user_in_db
    else
      false
    end
  end

  def sign_out(app, token)
    #TODO: El usuario que borra el token es el mismo que esta en el token
    token_repository.delete_token(app, token)
  end

  def get_all(app, query = {})
    users_repository.get_all app, query
  end



  private

  def resource_service
    ResourceService.new
  end

  def applicaton_repository 
    ApplicationMongoRepository.new
  end

  def users_repository 
    UserMongoRepository.new
  end

  def token_repository
    TokenMongoRepository.new
  end

  def token_service
    TokenService.new  
  end

  def remove_private_params hash_object
    hash_object.reject {|key, value| key[0,1] == '_' }
    hash_object.delete("password")
  end

end
