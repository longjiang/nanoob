module Blog::Public::ThemeConcern
  extend ActiveSupport::Concern

  included do
    extend         ClassMethods
    helper         HelperMethods
    layout            :layout
    #helper_method  :meta_title, :meta_description
    # before_action      :javascript_file
    # before_action      :stylesheet_file
    append_before_action :set_views_path
  end
  
  # def views_path
  #   "#{Rails.root}/app/views/themes/#{@website.theme}"
  # end
  
  def layout
    "application"
  end
  
  def default_render
      render template: "#{controller_name}/#{action_name}"
  end
  
  def set_views_path
    if parent_theme
      prepend_view_path "#{Rails.root}/app/themes/#{parent_theme}/views"
      prepend_view_path "#{Rails.root}/app/themes/#{parent_theme}/views/#{controller_name}"
      prepend_view_path "#{Rails.root}/app/themes/#{parent_theme}/views/application"
    end
    if theme
      prepend_view_path "#{Rails.root}/app/themes/#{theme}/views"
      prepend_view_path "#{Rails.root}/app/themes/#{theme}/views/#{controller_name}"
      prepend_view_path "#{Rails.root}/app/themes/#{theme}/views/application"
    end

  end
  
  def theme
    @theme ||= @website.theme
  end
  
  def parent_theme
    @parent_theme ||= @website.parent_theme || (@website.theme.eql?('simple') ? nil : 'simple')
  end

  protected

   module ClassMethods
   end
 
   module HelperMethods
     
     def render(*args)
       opts = args.shift
       if opts.is_a?(String)
         options = {partial: "/#{opts}"}
       else
         options = opts.merge(partial: "/#{opts[:partial]}")
       end
       super options
     end
     
     def asset_path(*args)
       opts = args.shift
       super "#{@website.theme}/#{opts}"
     end
     
     def stylesheet_link_tag(stylesheet, options={})
       super "#{@website.theme}/#{stylesheet}", options
     end
     
     def javascript_include_tag(js, options={})
       super "#{@website.theme}/#{js}", options
     end
     
   end
end







 



