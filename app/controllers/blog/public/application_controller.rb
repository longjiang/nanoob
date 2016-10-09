class Blog::Public::ApplicationController < ApplicationController
  
  filters = _process_action_callbacks.map(&:filter) 
  
  skip_before_action(*filters, raise: false)
  skip_after_action(*filters, raise: false)
  skip_around_action(*filters, raise: false)
  
  # skip_before_action :authenticate_user!
  # skip_before_action :init_menu
  # skip_before_action :menu_activate
  before_action :find_website
  before_action :set_locale
  
  
  
  include WoopraConcern
  
  private
  
  def blog_root_path
    @blog_root_path ||= "#{request.protocol}#{request.host_with_port}"
  end
  
  def find_website
    #TODO: save port in business_website.url
    blog_root_path
    @website ||= Business::Website.find_by_request(request)
  end
  
  def set_locale
    I18n.locale = :fr
  end

end