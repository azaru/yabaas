class ApplicationService
  
  def applicaton_repository 
    ApplicationMongoRepository.new
  end
end
