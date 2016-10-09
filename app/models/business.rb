
class Business < ApplicationRecord
  
  class Statistics
    attr_accessor :datas, :grouped_count, :grouped_total, :count, :total
    def initialize(datas=[], count=0, total=0)
      @datas = datas
      @count = count
      @total = total
    end
  end
  
  #enum language: [ :french, :english, :italian ]
  
  validates :name,                presence: true
  validates :business_product_id, presence: true
  validates :language,            presence: true
  
  has_many    :websites,   dependent: :destroy
  has_many    :requests,   dependent: :destroy,  class_name: 'Partner::Request'
  has_many    :backlinks,  dependent: :destroy,  class_name: 'Partner::Backlink'
  belongs_to  :product,                          class_name: 'Business::Product', foreign_key: :business_product_id
  belongs_to  :language,                         class_name: 'Business::Language', foreign_key: :business_language_id 
  has_many    :host_categorizations,         class_name: 'Seo::HostCategorization'
  has_many    :hosts, through: :host_categorizations
  
  delegate :name, to: :product, prefix: true
  
  def top_hosts(top=10)
    datas = Seo::Anchor
      .joins(:content, link: :host)
      .where(blog_contents: {business_website_id: websites.collect(&:id)})
      .group('seo_hosts.id')
      .count
      .sort{|a,b| b[1] <=> a[1]} 
    count = datas.size
    total = datas.inject(0) {|sum, item| sum + item[1]}
    stats = Statistics.new datas.shift(top).collect{|_| [Seo::Host.find(_[0]), _[1]]}, count, total
    stats.grouped_count = datas.count
    stats.grouped_total = datas.inject(0) {|sum, item| sum + item[1]}
    stats
  end
  
end

