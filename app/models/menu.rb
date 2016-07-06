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
  
  def activate(options)
    if (path = options[:path]).present?
      activate_by_path path
    elsif (id = options[:id]).present?
      activate_by_id id
    end
    
  end
  
  def build
    build! @items
  end
  
  private
  
  def activate_by_path(path, items=nil)
    items ||= @items
    items.each do |id, item|
      if /#{item[:url]}/i =~ path  
        items[id][:options][:active] = true
      elsif item[:children].present?
        activate_by_path path, item[:children]
      end
    end
  end
  
  def activate_by_id(id, items=nil)
    items ||= @items
    if items[id].present?
      items[id][:options][:active] = true
    else
      items.each do |_, item|
        activate_by_id(id, item[:children]) if item[:children].present?
      end
    end
  end
  
  def build!(items, level=0)
    return '' if items.nil?
    output = ''
    items.each do |id, item|
      is_active = !item[:options][:active].blank?
      options = item[:options].merge({submenu: build!(item[:children], level+1)})
      output += @markup[is_active ? 'active_item' : 'item'][:block].call(item[:body], item[:url], options)
    end
    @markup['container'][:block].call(output, {class: "submenu-#{level}"})
  end
end

