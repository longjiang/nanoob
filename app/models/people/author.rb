class People::Author < Person
  
  store_attribute :meta, :optimizer_id, Integer
  store_attribute :meta, :seo_score,    Integer, default: 0
  store_attribute :meta, :biography, String
  
  include Trackable
  
  def optimizer
    People::User.find(optimizer_id)
  end
  
end