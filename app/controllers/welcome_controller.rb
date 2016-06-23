class WelcomeController < ApplicationController
  
  before_action :add_menu_items
  
  private
  
  def add_menu_items
    #@menu.update "item3", "item4", root_path
  end
  
end
