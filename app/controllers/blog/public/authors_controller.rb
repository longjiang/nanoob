class Blog::Public::AuthorsController < Blog::Public::ContentsController
  
  def index
    @author = People::Author.find_by_username(params[:slug])
    render template: "themes/simple/author"
  end
  
  def page_title
    @author.decorate.name
  end
  
end