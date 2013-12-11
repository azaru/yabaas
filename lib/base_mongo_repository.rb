class BaseMongoRepository
    
    def connection
      @@conn ||= Moped::Session.new(["127.0.0.1:27017"])
    end

    def database(db,coll) 
    session = connection
 #   session.with(safe: true)
    session.use db.to_s
    session[coll.to_s]
  end

end