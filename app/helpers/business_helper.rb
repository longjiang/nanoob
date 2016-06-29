module BusinessHelper
  def flag(language)
    iso = case language
    when "french"
      "fr"
    when "english"
      "gb"
    when "italian"
      "it"
    else
      '_unknown'
    end
    image_tag "icons/flags-16/#{iso}.png", alt: language
  end
end
