module ControllerHelpers
  def login_with(user = double('user'), scope = :user)
    current_user = "current_#{scope}".to_sym
    if user.nil?
      allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => scope})
      allow(controller).to receive(current_user).and_return(nil)
    else
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(current_user).and_return(user)
    end
  end
  
  def attributes_with_foreign_keys(*args)
    FactoryGirl.build(*args).attributes.delete_if do |k, v|
       ["id", "type", "created_at", "updated_at"].member?(k) || v.nil?
     end
  end
  
  def post_with_role(user_role)
    #puts "**************** USER_ROLE #{user_role}"
    post = case user_role
    when 'owner'
      FactoryGirl.create(:post, owner: user, status: status)
    when 'editor'
      FactoryGirl.create(:post, editor: user, status: status)
    when 'writer'
      FactoryGirl.create(:post, writer: user, status: status)
    when 'optimizer'
      FactoryGirl.create(:post, optimizer: user, status: status)
    else
      FactoryGirl.create(:post, status: status)
    end
    #puts "*********** STATUS #{post.status}"
    post
  end
end