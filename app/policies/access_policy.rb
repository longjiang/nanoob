class AccessPolicy
  include AccessGranted::Policy

  def configure
    # Example policy for AccessGranted.
    # For more details check the README at
    #
    # https://github.com/chaps-io/access-granted/blob/master/README.md
    #
    # Roles inherit from less important roles, so:
    # - :admin has permissions defined in :member, :guest and himself
    # - :member has permissions from :guest and himself
    # - :guest has only its own permissions since it's the first role.
    #
    # The most important role should be at the top.
    # In this case an administrator.
    #
    # role :admin, proc { |user| user.admin? } do
    #   can :destroy, User
    # end

    # More privileged role, applies to registered users.
    #
    # role :member, proc { |user| user.registered? } do
    #   can :create, Post
    #   can :create, Comment
    #   can [:update, :destroy], Post do |post, user|
    #     post.author == user
    #   end
    # end

    # The base role with no additional conditions.
    # Applies to every user.
    #
    # role :guest do
    #  can :read, Post
    #  can :read, Comment
    # end
    
    role :admin, proc {|user| user.has_role?(:admin)} do
      can [:update, :delete, :assign], Blog::Contents::Post
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
    
    
    role :editor, proc {|user| user.has_role?([:admin, :editor])} do
      can :publish, Blog::Contents::Post do |post, user|
        post.owner.eql?(user) && (post.submitted? || post.draft?) || post.editor.eql?(user) && post.submitted? || post.writer.eql?(user) && post.draft?
      end
    end
    
    
    role :blogger, proc {|user| user.has_role?([:admin, :editor, :blogger])} do
      
      # Pages
      can [:list, :read, :create], Blog::Contents::Page
      
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
      can :delete, Blog::Contents::Post do |post, user|
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
      can [:list, :read], People::Author
    end
    
  end
end
