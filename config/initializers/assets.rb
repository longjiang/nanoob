# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
#Rails.application.config.assets.precompile += %w( **/javascripts/index.js )
#Rails.application.config.assets.precompile += [ "./**/javascripts/index.js" ]

#Rails.application.config.assets.precompile += Dir.glob(Rails.root.join('app', 'themes', '**', 'assets', 'javascripts', 'index.js'))

Dir.glob(Rails.root.join('app', 'themes', '**')).map{|d| File.basename(d)}.each do |theme|

  Rails.application.config.assets.precompile += [  "#{theme}/index.css", "#{theme}/index.js" ]

end


