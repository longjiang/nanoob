class Dashboard::Card
  
  attr_accessor :template, :options
  
  def initialize(options={})
    @options = {template: 'one'}.merge(options)
    @template = "card_#{@options.delete(:template)}"
  end
  
  def markup(options={}, &block)
    @markup = { :block => block, :options => options } 
  end
  
  def build(markup=nil)
    markup = @markup unless markup
    markup[:block].call(options.merge(markup[:options]))
  end
  
end