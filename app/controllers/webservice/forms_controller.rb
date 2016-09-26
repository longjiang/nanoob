class Webservice::FormsController < ApplicationController
  
  def blog_page_slug_generator
    slug = Blog::Page.slugify(params[:attr])
    render json: {"slug": slug}
  end
  
  def blog_page_permalink_prefix
    website = Business::Website.find(params[:website_id])
    page = Blog::Page.new
    page.website = website
    render json: {"permalink_prefix": page.decorate.permalink_prefix}
  end
  
  def blog_post_slug_generator
    slug = Blog::Post.slugify(params[:attr])
    render json: {"slug": slug}
  end
  
  def blog_post_permalink_prefix
    website = Business::Website.find(params[:website_id])
    post = Blog::Post.new
    post.website = website
    render json: {"permalink_prefix": post.decorate.permalink_prefix}
  end
  
  def blog_category_slug_generator
    website = Business::Website.find(params[:website_id])
    slug = Blog::Taxonomies::Category.slugify(website, params[:attr])
    render json: {"slug": slug}
  end
  
  def blog_category_permalink_prefix
    website = Business::Website.find(params[:website_id])
    category = Blog::Taxonomies::Category.new
    category.website = website
    render json: {"permalink_prefix": category.decorate.permalink_prefix}
  end
  
  def blog_page_published_at
    year,month,day,hour,minute = params[:date].split(',').map{|i| i.to_i}
    render json: {"date": Blog::Page.new(published_at: Time.new(year,month,day,hour,minute)).decorate.published_at}
  end
  
  def blog_post_published_at
    year,month,day,hour,minute = params[:date].split(',').map{|i| i.to_i}
    render json: {"date": Blog::Post.new(published_at: Time.new(year,month,day,hour,minute)).decorate.published_at}
  end
  
  
end