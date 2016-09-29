class People::UserDecorator < PeopleDecorator
  
  def name
    object.username.humanize
  end
  
  def name_with_roles
    roles = object.roles.any? ? " (#{object.roles.sort.join(', ')})" : ""
    "#{object.username.humanize}#{roles}"
  end
  
  def self.icon
    'user'
  end
  
end
