class TokenMongoRepository < BaseMongoRepository

  def new_token(app, user)
    token = {}
    token['obj_id'] = user['_id']
    token['token'] = SecureRandom.uuid
    database(app, :tokens).insert(token)
    token['token']
  end

  def delete app, token
    database(app, :tokens).find(token: token['token']).remove
  end

  def get_from_token(app, token)
   database(app, :tokens).find(token: token).one
  end

  def token_exist?(app, token)
    db_token = database(app, :tokens).find(token: token)
    db_token.count > 0
  end
end