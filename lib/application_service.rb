class ApplicationService
  def by_id(id)
    applicaton_repository.by_id id
  end

  def applicaton_repository 
    ApplicationMongoRepository.new
  end
end