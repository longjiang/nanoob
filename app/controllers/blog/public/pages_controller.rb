class Blog::Public::PagesController < Blog::Public::ContentsController
  
  
  def show
    @page = Blog::Contents::Page.website(@website).find_by_slug!(params[:slug])
    render template: "themes/simple/page"
  end
  
end