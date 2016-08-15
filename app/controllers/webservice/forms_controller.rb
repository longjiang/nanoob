class Webservice::FormsController < ApplicationController
  
  def blog_post_slug_generator
    slug = Blog::Post.slugify(params[:title])
    render json: {"slug": slug}
  end
  
  def permalink_prefix
    website = Business::Website.find(params[:website_id])
    post = Blog::Post.new
    post.website = website
    render json: {"permalink_prefix": post.decorate.permalink_prefix}
  end
  
  
end