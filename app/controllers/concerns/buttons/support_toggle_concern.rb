
module Buttons::SupportToggleConcern
  extend ActiveSupport::Concern

  included do
    extend         ClassMethods
    helper         HelperMethods
    helper_method  :support_target_id
  end
  
  attr_accessor :support_target_id
  
  protected
  
   module ClassMethods
     def support_toggle_button(target='offcanvas-aside-right', actions=[:new, :edit])
       append_before_action only: actions do |controller|
         controller.send("support_target_id=", target)
        end
     end
   end
   
   module HelperMethods
     def render_button_support_toggle
       render partial: 'shared/buttons/support_toggle', locals: {target: support_target_id} unless support_target_id.blank?
     end
   end
end