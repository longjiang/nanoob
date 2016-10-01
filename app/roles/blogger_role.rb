class BloggerRole < AccessGranted::Role
  def configure
    #
    # Pages
    #
    can [:list, :read, :create], Blog::Contents::Page
    can :update, Blog::Contents::Page do |post, user|
      post.owner.eql?(user) || post.optimizer.eql?(user)
    end
    
    # 
    # Posts
    #
    
    # Anyone can list, read or create
    can [:list, :read, :create], Blog::Contents::Post
    
    # writers can update their drafts
    # owners can always update
    # optimizers can update submitted or published
    can :update, Blog::Contents::Post do |post, user|
      post.writer.eql?(user) && post.draft? || post.editor.eql?(user) && post.submitted? || post.owner.eql?(user) || post.optimizer.eql?(user) && (post.submitted? || post.published?)
    end
    
    # writers can delete their drafts
    # owners can always delete
    can :destroy, Blog::Contents::Post do |post, user|
      post.writer.eql?(user) && post.draft? || post.editor.eql?(user) && post.submitted? || post.owner.eql?(user)
    end
    
    # owners can unpublish
    can :unpublish, Blog::Contents::Post do |post, user|
      post.owner.eql?(user) && post.published?
    end
    
    # writers can submit draft
    # owners can submit draft
    can :submit, Blog::Contents::Post do |post, user|
      (post.writer.eql?(user) || post.owner.eql?(user)) && post.draft?
    end
    
    # editors can refuse 
    # owners can refuse
    can :refuse, Blog::Contents::Post do |post, user|
      (post.editor.eql?(user) || post.owner.eql?(user)) && post.submitted?
    end
    
    # owners can assign (writer, editor, optimizer, owner)
    can :assign, Blog::Contents::Post do |post, user|
      post.owner.eql?(user)
    end
    
    
    # Taxonomies
    can [:list, :read], Blog::Taxonomies::Category
    can [:list, :read], Blog::Taxonomies::Tag
    can [:list, :read], Business::Website
    
    # authors
    can [:list, :read], People::Author
    can :update, People::Author do |author, user|
      author.optimizer_id.eql?(user.id)
    end
  end
end