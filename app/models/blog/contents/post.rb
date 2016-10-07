class Blog::Contents::Post < Blog::Content
  
  belongs_to :website,  class_name: 'Business::Website', foreign_key: :business_website_id, counter_cache: true
  belongs_to :owner,                      class_name: 'People::User',  foreign_key: :owner_id,     counter_cache: true
  belongs_to :editor,    optional: true,  class_name: 'People::User',  foreign_key: :editor_id,    counter_cache: true
  belongs_to :writer,    optional: true,  class_name: 'People::User',  foreign_key: :writer_id,    counter_cache: true
  belongs_to :optimizer, optional: true,  class_name: 'People::User',  foreign_key: :optimizer_id, counter_cache: true
  has_and_belongs_to_many :categories,  class_name: 'Blog::Taxonomies::Category',   foreign_key: :blog_content_id, association_foreign_key: :blog_taxonomy_id , after_add: :increment_category_count, after_remove: :decrement_category_count
  has_and_belongs_to_many :tags,        class_name: 'Blog::Taxonomies::Tag',        foreign_key: :blog_content_id, association_foreign_key: :blog_taxonomy_id , after_add: :increment_tag_count, after_remove: :decrement_tag_count
  has_many :stop_words    , class_name: 'Seo::StopWord'       , as: :excludable, dependent: :delete_all
  has_many :words         , class_name: 'Seo::Word'           , as: :word_countable, dependent: :delete_all

  delegate :username, to: :writer, prefix: true, allow_nil: true
  delegate :username, to: :editor, prefix: true, allow_nil: true
  delegate :username, to: :optimizer, prefix: true, allow_nil: true 
  
  has_meta :words_count
  
  before_save :update_statistics
  
  def language
    @language ||= Business::Language.find_by_name('french')
  end
  
  def words_count
    @words_count ||= get_meta(:words_count).present? ? get_meta(:words_count).to_i : 0
  end
  
  def set_words_count
    counter = WordsCounted.count sanitized_body
    self.words_count = counter.token_count
    @words_count = counter.token_count
  end
  
  
  def all_stop_words
    @all_stop_words ||= language.stop_words.collect(&:word) rescue nil
  end
  
  def tokens
    @tokens ||= WordsCounted::Tokeniser.new(sanitized_body).tokenise(exclude: all_stop_words, pattern: /[\p{Alpha}\-]+/)
  end
  
  def counter
    @counter ||= WordsCounted::Counter.new tokens 
  end
  
  def count_words
    self.words = counter.token_frequency.collect { |token, frequency| Seo::Word.new(word: token, frequency: frequency) } 
  end
  
  def update_anchors
    old_anchors_ids = anchors.collect(&:id)
    new_anchors_ids = []
    Nokogiri::HTML(body).css("a").each do |a|
      url = a.attr('href')
      image_url = nil
      if a.css('img').blank?
        anchor_text = a.content.strip
      else
        anchor_text = '[image]'
        image_url = a.css('img').first.attr('src')
      end
      uri = URI(url)
      puts "domain: #{uri.host} - url: #{url} - anchor: #{anchor_text} #{image_url}"
      
      domain = Seo::Domain.find_or_create_by(url: uri.host)
      link = domain.links.find_or_create_by(url: url)
      a = self.anchors.find_or_create_by(link: link, text: anchor_text, image_url: image_url)
      new_anchors_ids << a.id
    end
    
    delete_ids = old_anchors_ids - new_anchors_ids
    self.anchors.where(id: delete_ids).each {|a| a.destroy }
  end
  
  def update_statistics
    if body_changed?
      set_words_count
      count_words
      update_anchors
    end
  end
  
  def init_statistics
    if words_count.eql?(0)
      set_words_count
      count_words
    end
    if anchors.size.eql?(0)
      update_anchors
    end
    self.save(touch: false)
  end
  
end
