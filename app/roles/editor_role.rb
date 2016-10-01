class EditorRole < AccessGranted::Role
  def configure
    can :publish, Blog::Contents::Post do |post, user|
      post.owner.eql?(user) && (post.submitted? || post.draft?) || post.editor.eql?(user) && post.submitted? || post.writer.eql?(user) && post.draft?
    end
  end
end