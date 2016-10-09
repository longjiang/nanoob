
module Buttons::IndexAddnewConcern
  extend ActiveSupport::Concern

  included do
    extend         ClassMethods
    helper         HelperMethods
    helper_method  :addnew_path
  end
  
  protected
  
  def addnew_path
    @addnew_path
  end
  
  def addnew_path=(path)
    @addnew_path = path
  end
  
  def new_object_path
  end
  
   module ClassMethods
     def index_addnew_button(path=nil)
       before_action only: [:index] do |controller|
         controller.send("addnew_path=", path || new_object_path) if can? :create, controller_path.singularize.camelize.constantize
        end
     end
   end
   
   module HelperMethods
     def render_button_index_addnew
       render partial: 'shared/buttons/index_addnew', locals: {path: addnew_path} unless addnew_path.blank?
     end
   end
end