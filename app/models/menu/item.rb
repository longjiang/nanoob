#
# Add an item to a menu
#
# ==== Examples
# = Basic
# menu.add "link_text", "url"
# = With id in order to update it if needed (is a second controller)
# menu.add "link_text", "url", "menu_id"
# = with options
# menu.add "link_text", "url", {active: true, class: "item"}


class Menu::Item
  
  attr_accessor :items
  
  def initialize(options={}, &block)
    @items = options[:items] || {}
    yield(self)
  end
  
  def add(body, url, *args, &block)
    add! body, url, true, *args, &block
  end
  
  def update(body, url, *args, &block)
    add! body, url, false, *args, &block
  end
  
  private
  
  def add!(body, url, force, *args, &block)
    begin
      parse args, url
    rescue ArgumentError => e
      raise ArgumentError, "Can't add menu (id: `#{@id}`, url: `#{url}`, body: `#{body}`). #{e}"
    end
    raise "Can't add menu. Id `#{@id}` already exists. Use update instead." unless (@items[@id].blank? || force)
    children = block_given? ? { children: self.class.new(&block).items} : {}
    @items[@id] = { body: body, url: url }.merge(@options).merge(children)
  end
  
  def parse(args, url)
    @id = "itemID#{url.parameterize}"
    @options = {}
    case args.size
    when 0
    when 1
      if args[0].is_a?(String)
        @id = args[0]
      elsif args[0].is_a?(Hash)
        @options = args[0]
      else
        raise ArgumentError, "3rd Argument should be a String or a Hash"
      end
    when 2
      if args[0].is_a?(String) && args[1].is_a?(Hash)
        @id = args[0]
        @options = args[1]
      else
        raise ArgumentError, "3rd Argument should be a String, 4th argument should be a Hash"
      end
    else
      raise ArgumentError, "wrong number of arguments (given #{args.size + 2}, expected 2..4)."
    end
  end
  
end
