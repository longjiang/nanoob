class Webservice::FormsController < ApplicationController
  
  before_action :find_website, only: [:blog_slug_generator, :blog_permalink_prefix]
  before_action :klass, only: [:blog_slug_generator, :blog_permalink_prefix]
  
  def blog_slug_generator
    render json: {"slug": @klass.slugify(params[:label], @website)}
  end
  
  def blog_permalink_prefix
    o = @klass.new
    o.website = @website
    render json: {"permalink_prefix": o.decorate.permalink_prefix}
  end
  
  def blog_page_published_at
    year,month,day,hour,minute = params[:date].split(',').map{|i| i.to_i}
    render json: {"date": Blog::Contents::Page.new(published_at: Time.new(year,month,day,hour,minute)).decorate.published_at}
  end
  
  def blog_post_published_at
    year,month,day,hour,minute = params[:date].split(',').map{|i| i.to_i}
    render json: {"date": Blog::Contents::Post.new(published_at: Time.new(year,month,day,hour,minute)).decorate.published_at}
  end
  
  private
  
  def klass
    @klass ||= "Blog::#{params[:klass]}".constantize
  end
  
  def find_website
    @website = Business::Website.find(params[:website_id])
  end
  
  
end