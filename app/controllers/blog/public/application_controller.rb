class Blog::Public::ApplicationController < ApplicationController
  
  skip_before_action :authenticate_user!
  skip_before_action :init_menu
  skip_before_action :menu_activate
  prepend_before_action :find_website
  prepend_before_action :set_locale
  
  
  
  include WoopraConcern
  
  private
  
  def blog_root_path
    @blog_root_path ||= "#{request.protocol}#{request.host_with_port}"
  end
  
  def find_website
    #TODO: save port in business_website.url
    blog_root_path
    @website ||= Business::Website.find_by_url("#{request.protocol}#{request.host.gsub('.dev','').gsub('www.','')}")
  end
  
  def set_locale
    I18n.locale = :fr
  end

end