class TokenMongoRepository < BaseMongoRepository

  def new_token(app, user)
    token = {}
    token['obj_id'] = user['_id']
   # token['lastUse'] = Date.new
    token['token'] = SecureRandom.uuid
    database(app, :tokens).insert(token)
    token['token']

    # TODO: Asegurarse de que se a guardado correctamenete (con la salida)
  end

  def delete app, token
    database(app, :tokens).find(token: token['token']).remove
  end

  def update_token_expiration app, token
    # TODO: poner los eventos en cada DB para que funcione
    # ensureIndex( { "lastUse": 1 }, { expireAfterSeconds: 3600 } )
    database(app, :tokens).find(_id: token['_id']).update("$set" => {lastUse: Date.new})
  end

  def get_from_token(app, token)
   database(app, :tokens).find(token: token).one
  end

  def token_exist?(app, token)
    db_token = database(app, :tokens).find(token: token)
    db_token.count > 0
  end
end