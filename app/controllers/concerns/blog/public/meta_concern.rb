module Blog::Public::MetaConcern
  extend ActiveSupport::Concern

  included do
    extend         ClassMethods
    helper         HelperMethods
    helper_method  :meta_title, :meta_description
  end

  protected
  
  def page_title_template
    @website.decorate.page_title_template
  end
  
  # method used in templates
  def page_title
  end
  
  # method used in templates
  def sitename
    @website.decorate.title
  end
  
  # generate page title
  def meta_title
    @meta_title ||= page_title_template.gsub(/%%([_a-z]+)%%/) { |s| send(:"#{$1}") rescue ''}
  end
  
  def meta_description
  end

   module ClassMethods
   end
 
   module HelperMethods
     def page_title
       "<title>#{meta_title}</title>".html_safe if meta_title
     end
     def page_description
       "<meta name='description' content='#{meta_description}'>".html_safe if meta_description
     end
   end
end
