
module Buttons::EditCancelConcern
  extend ActiveSupport::Concern

  included do
    extend         ClassMethods
    helper         HelperMethods
    helper_method  :cancel_path
  end
  
  protected
  
  def cancel_path
    @cancel_path
  end
  
  def cancel_path=(path)
    @cancel_path = path
  end
  
   module ClassMethods
     def edit_cancel_button
       append_before_action only: [:edit] do |controller|
         controller.send("cancel_path=", url_for(action: 'show', controller: controller_path)) if can? :read, entry
        end
     end
   end
   
   module HelperMethods
     def render_button_edit_cancel
       render partial: 'shared/buttons/edit_cancel', locals: {path: cancel_path} unless cancel_path.blank?
     end
   end
end