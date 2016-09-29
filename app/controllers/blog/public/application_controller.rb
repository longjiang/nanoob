class Blog::Public::ApplicationController < ApplicationController
  
  skip_before_action :authenticate_user!
  skip_before_action :init_menu
  skip_before_action :menu_activate
  skip_after_action  :save_filter
  before_action      :find_website
  
  private
  
  def blog_root_path
    @blog_root_path ||= "#{request.protocol}#{request.host_with_port}"
  end
  
  def find_website
    #TODO: save port in business_website.url
    blog_root_path
    @website ||= Business::Website.find_by_url("#{request.protocol}#{request.host.gsub('.dev','').gsub('www.','')}")
  end
  

  
end