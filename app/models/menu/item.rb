class Menu::Item
  
  attr_accessor :items
  
  def initialize(options={}, &block)
    @items = {}
    yield(self)
  end
  
  def add(id, body, url, options={}, &block)
    raise "id exists" unless @items[id].blank?
    add!(id, body, url, options={}, &block)
  end
  
  def update(id, body, url, options={}, &block)
    add!(id, body, url, options={}, &block)
  end
  
  private
  
  def add!(id, body, url, options={}, &block)
    children = block_given? ? { children: self.class.new(&block).items} : {}
    @items[id] = { body: body, url: url }.merge(options).merge(children)
  end
  
end
