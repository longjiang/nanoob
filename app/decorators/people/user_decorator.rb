class People::UserDecorator < PeopleDecorator
  
  def name
    object.username.humanize
  end
  
  def self.icon
    'user'
  end
end
