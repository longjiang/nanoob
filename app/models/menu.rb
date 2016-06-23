class Menu
  
  def initialize(options={}, &block)
    @items = Menu::Item.new(options, &block).items
    @markup = {}
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

