class Blog::Public::PagesController < Blog::Public::ContentsController
  
  include Blog::Public::ThemeConcern
  
  def show
    @page = Blog::Contents::Page.website(@website).find_by_slug!(params[:slug])
    @page.track self
  end
  
end