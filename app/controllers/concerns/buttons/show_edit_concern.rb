
module Buttons::ShowEditConcern
  extend ActiveSupport::Concern

  included do
    extend         ClassMethods
    helper         HelperMethods
    helper_method  :edit_path
  end
  
  protected
  
  def edit_path
    @edit_path
  end
  
  def edit_path=(path)
    @edit_path = path
  end
  
   module ClassMethods
     def show_edit_button
       append_before_action only: [:show] do |controller|
         controller.send("edit_path=", url_for(action: 'edit', controller: controller_path)) if can? :update, entry
        end
     end
   end
   
   module HelperMethods
     def render_button_show_edit
       render partial: 'shared/buttons/show_edit', locals: {path: edit_path} unless edit_path.blank?
     end
   end
end