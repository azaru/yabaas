class App
  include Mongoid::Document
  belongs_to :client
  field :name, type: String
  field :description, type: String
end