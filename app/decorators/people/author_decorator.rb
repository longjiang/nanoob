class People::AuthorDecorator < PeopleDecorator
  
  def name
    object.username.humanize
  end
  
  def self.icon
    'paw'
  end
end
