module Blog::Public::ThemeConcern
  extend ActiveSupport::Concern

  included do
    extend         ClassMethods
    helper         HelperMethods
    prepend_view_path "#{Rails.root}/app/themes/simple/views"
    prepend_view_path "#{Rails.root}/app/themes/simple/views/#{controller_name}"
    prepend_view_path "#{Rails.root}/app/themes/simple/views/application"
    layout            :layout
    #helper_method  :meta_title, :meta_description
    # before_action      :javascript_file
    # before_action      :stylesheet_file
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







 



