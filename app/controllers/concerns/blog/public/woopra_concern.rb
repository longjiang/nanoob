
module Blog::Public::WoopraConcern
  extend ActiveSupport::Concern

  included do
    extend         ClassMethods
    helper         HelperMethods
    helper_method  :woopra_tracker, :woopra_events
  end

  protected

  def woopra_track(action=nil, options={})
    return unless woopra
    case action
    when nil
      woopra.track
    else
      woopra.track action, options
    end
  end

  def woopra
    @woopra ||= init_woopra
  end

  def init_woopra
    if @website && domain=@website.woopra
      @woopra = WoopraTracker.new(request)
      @woopra.config({domain: domain})
    end
    @woopra
  end

  def woopra_tracker
    woopra_track if @woopra.nil?
    woopra.js_code.html_safe unless woopra.blank?
  end
  
  def woopra_events
    woopra_track if @woopra.nil?
    woopra.js_events.html_safe unless woopra.blank?
  end

   module ClassMethods
   end
 
   module HelperMethods
   end
end
