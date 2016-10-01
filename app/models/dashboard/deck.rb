class Dashboard::Deck
  
  attr_accessor :cards, :template, :markup
  
  def initialize(options={}, &block)
    @options    = {template: 'one'}.merge(options)
    @template   = "deck_#{@options[:template]}"
    @cards      = []
    @markup     = {}
    @templates  = [@template]
    yield self
  end
  
  def markup(type, options={}, &block)
    @markup[type] = { :block => block, :options => options } 
  end
  
  def add(params={})
    card = Dashboard::Card.new(params.merge(@options))
    @templates << card.template
    @cards << card
  end
  
  def templates
    @templates.uniq
  end
  
  def build
    output = ''
    @cards.each do |card|
      output += card.build(@markup[card.template])
    end
    @markup[template][:block].call(output)
  end
  
end

