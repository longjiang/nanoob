module Blog::Public::PathsHelper
  
  def author_path(author)
    super slug: author.username.parameterize, id: author.id
  end
  
end