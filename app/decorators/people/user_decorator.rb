class People::UserDecorator < PeopleDecorator
  
  def name
    object.username.humanize
  end
  
  def name_with_roles
    roles = object.roles.any? ? " (#{object.roles.sort.join(', ')})" : ""
    "#{object.username.humanize}#{roles}"
  end
  
  def self.collection
    People::User.order(:username).all.map{|_| [_.decorate.name_with_roles, _.id]}
  end
  
  def self.icon
    'user'
  end
  
end
