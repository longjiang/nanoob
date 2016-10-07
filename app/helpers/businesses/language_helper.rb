module Businesses::LanguageHelper
  def flag(isocode, alt=nil)
    iso = %w(fr gb it).include?(isocode) ? isocode : '_unknown'
    alt = iso if alt.blank?
    image_tag "icons/flags-16/#{iso}.png", alt: alt
  end
end