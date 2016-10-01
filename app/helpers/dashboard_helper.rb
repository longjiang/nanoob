module DashboardHelper
  def render_deck
    if @deck
      @deck.templates.each do |template|
        @deck.markup(template) do |content|
          render partial: "dashboard/#{template}", locals: {content: content}
        end
      end
      @deck.build.html_safe
    end
  end
  
  def render_card(card)
    card.markup do |content|
      render partial: "dashboard/#{card.template}", locals: {content: content}
    end
    card.build.html_safe
  end
end