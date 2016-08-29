module ControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      admin = FactoryGirl.create(:admin)
      sign_in :user, admin # sign_in(scope, resource)
    end
  end

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryGirl.create(:user)
      #user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
      sign_in user
    end
  end
  
  def attributes_with_foreign_keys(*args)
    FactoryGirl.build(*args).attributes.delete_if do |k, v| 
      ["id", "type", "created_at", "updated_at"].member?(k)
    end
  end
    
end