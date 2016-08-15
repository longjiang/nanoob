
module IndexAddnewConcern
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
  
  def index_addnew(path)
    @addnew_path = path
  end
  
  def new_object_path
  end
  
   module ClassMethods
     def index_addnew(path=nil)
       before_action only: [:index] do |controller|
         controller.send(:index_addnew, path || new_object_path)
        end
     end
   end
   
   module HelperMethods
     def render_index_addnew
       render partial: 'shared/index_addnew', locals: {path: addnew_path} unless addnew_path.blank?
     end
   end
end