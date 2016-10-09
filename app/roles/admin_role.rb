class AdminRole < AccessGranted::Role
  def configure
    
    can [:create, :update, :destroy], Business
    
    
    can [:update, :destroy, :assign], Blog::Contents::Post
    can :publish, Blog::Contents::Post do |post|
      post.draft? || post.submitted?
    end
    can :submit, Blog::Contents::Post do |post|
      post.draft?
    end
    can :refuse, Blog::Contents::Post do |post|
      post.submitted?
    end
    can :unpublish, Blog::Contents::Post do |post|
      post.published?
    end 
  end
end