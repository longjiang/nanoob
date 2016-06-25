# == build a menu
#
# Object is defined in controller and rendered in a view
# based on templates located in +views/menu+
#
# See menu/item.rb for details how to add an item
#
# ==== Examples
# in controller
# 
# to create a menu (in application_controller)
#
#   @menu = Menu.new do |menu|
#     menu.add "item1", '/path' do |submenu|
#       submenu.add "item2", "/path2"
#       submenu.add "item3", "/path3"
#     end
#   end
#
# to update a menu (in any controller)
# @menu.update do |menu|
#   menu.add "item4", '/path4'
# end
#
# In a view
# call a helper method +sidebar_menu+
#
# 


class Menu
  
  def initialize(options={}, &block)
    @items = Menu::Item.new(options, &block).items
    @markup = {}
  end
  
  def update(options={}, &block)
    @items = Menu::Item.new(options.merge(items: @items), &block).items
  end
  
  def markup(type, options={}, &block)
   @markup[type] = { :block => block, :options => options } 
  end
  
  def build
    build! @items
  end
  
  private
  
  def build!(items, level=0)
    return '' if items.nil?
    output = ''
    items.each do |id, item|
      is_active = !item[:active].blank?
      output += @markup[is_active ? 'active_item' : 'item'][:block].call(item[:body], item[:url], {submenu: build!(item[:children], level+1)})
    end
    @markup['container'][:block].call(output, {class: "submenu-#{level}"})
  end
end

