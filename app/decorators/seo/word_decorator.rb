class Seo::WordDecorator < ApplicationRecordDecorator
  
  def name
    object.word.humanize
  end
  
  def density(precision=5)
    if (total = object.word_countable.try(:words_count)) > 0
      (object.frequency / total.to_f).round(precision)
    end
  end
  
  def self.icon
    'cube'
  end
  
end
