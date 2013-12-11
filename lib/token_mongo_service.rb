class TokenMongoService < BaseService

  def get_from_token app, token
    db_token = token_repository.get_from_token app, token
    user_repository.find_by_id(app, db_token['obj_id'])
  end

  def token_exist? app, token
    token_repository.token_exist? app, token
  end

  def delete app, token
    db_token = token_repository.get_from_token app, token
    token_repository.delete app, db_token
  end

  private 

  def token_repository
    TokenMongoRepository.new
  end

  def user_repository
    UserMongoRepository.new
  end
end