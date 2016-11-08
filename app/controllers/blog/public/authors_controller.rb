class Blog::Public::AuthorsController < Blog::Public::ContentsController
  
  include Blog::Public::ThemeConcern
  
  def show
    @author = People::Author.find(params[:id].to_i).try(:decorate)
    @author.track self
  end
  
  def page_title
    @author.decorate.name
  end

end