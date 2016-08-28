class Blog::PostDecorator < ApplicationRecordDecorator
  delegate_all

  SEO_SCORE_COLOR_OPTIONS = {default: 'muted', ok: 'success', ko: 'danger'}
  STATUS_COLOR_OPTIONS = {default:'muted', draft:'muted', scheduled: 'primary', published:'success'}
  STATUS_ICON_OPTIONS = {default:'thumb-tack', draft:'pencil-square-o', scheduled: 'calendar-check-o', published:'check-circle-o'}
  
  def categories(params={})
    return "-" if object.categories.blank?
    object.categories.map do |category|
      if params[:category_id].eql?(category.id.to_s)
        h.link_to category.name, h.filtered_entries_path(category_id: nil), class: 'text-primary'
      else
        h.link_to category.name, h.filtered_entries_path(category_id: category.id)
      end
    end.join(', ').html_safe
  end
  
  def status_with_date
    date = case object.status
    when "published"
      object.published_at
    else
      object.updated_at
    end
    "#{h.t(status, scope: 'activerecord.attributes.blog/post.decorator.statuses')} #{time_ago_in_words_or_date date}"
  end
  
  def status
    if object.published?
      object.published_at > Time.now ? :scheduled : :published
    else
      :draft
    end 
  end
  
  def published_at
    time_ago_in_words_or_datetime(object.published_at)
  end
  
  def seo_score_color
    option :SEO_SCORE_COLOR, object.seo_score
  end
  
  def excerpt
    h.truncate(ActionView::Base.full_sanitizer.sanitize(object.body), length: 100)
  end
  
  def status_color
   option :status_color, status
  end
  
  def status_icon
   option :status_icon, status
  end
  
  def body_xs_if_error_class
    "has-error" if object.errors && object.errors[:body_xs].present?
  end
  
  def permalink_prefix
    if object.website.present?
      "#{object.website.url}/#{object.year}/#{object.month}/"
    else
      ""
    end
  end
  

  
  def self.icon
    'thumb-tack'
  end

end
