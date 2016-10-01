class AccessPolicy
  include AccessGranted::Policy
  
  CONFIG = { admin: [], webmaster: [], editor: [], blogger: [:editor] }

  def configure
    
    CONFIG.each do |roleName, additionalRoles|
      roles = ([:admin, roleName] + additionalRoles).uniq
      role roleName, "#{roleName.capitalize}Role".constantize, lambda {|user| user.has_role?(roles)}
    end

  end
end
