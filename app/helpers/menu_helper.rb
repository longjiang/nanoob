module MenuHelper
  def sidebar_menu
    @menu.markup('item') do |body, url, options|
      render :partial => "menu/item", :locals => { :body => body, :url => url, :options => options }
    end
    @menu.markup('active_item') do |body, url, options|
      render :partial => "menu/active_item", :locals => { :body => body, :url => url, :options => options }
    end
    @menu.markup('container') do |items, options|
      render :partial => "menu/container", :locals => { :items => items, :options => options}
    end
    @menu.build.html_safe
  end
end