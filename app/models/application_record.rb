class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  before_validation :nilify_blanks
  
  private
  
  def nilify_attributes
    []
  end
  
  def nilify_blanks
    nilify_attributes.each { |attr| self[attr] = nil if self[attr].blank? }
  end
  
end
