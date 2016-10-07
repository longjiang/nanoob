class Blog::Public::AuthorsController < Blog::Public::ContentsController
  
  def index
    @author = People::Author.find(params[:id].to_i)
    @author.track self
    render template: "themes/simple/author"
  end
  
  def page_title
    @author.decorate.name
  end
  
end