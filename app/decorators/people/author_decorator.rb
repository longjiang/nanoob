class People::AuthorDecorator < PeopleDecorator
  
  def name
    if object.firstname.blank?
      object.username.humanize
    else
      "#{object.firstname} #{object.lastname}"
    end
  end
  
  def self.icon
    'paw'
  end
end
