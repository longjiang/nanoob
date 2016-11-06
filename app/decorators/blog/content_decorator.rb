class Blog::ContentDecorator < ApplicationRecordDecorator
  delegate_all

  SEO_SCORE_COLOR_OPTIONS = {default: 'muted', ok: 'success', ko: 'danger'}
  STATUS_COLOR_OPTIONS = {default:'muted', draft:'muted', submitted: 'primary', scheduled: 'success', published:'success'}
  STATUS_ICON_OPTIONS = {default:'thumb-tack', draft:'pencil-square-o', submitted: 'pencil-square-o', scheduled: 'calendar-check-o', published:'check-circle-o'}
  USER_TYPE_ICON_OPTIONS = {default:'', owner:'user', editor:'legal', optimizer:'graduation-cap', writer:'pencil'}
  ATTR_ICON_OPTIONS = {comments_count: 'comment-o', views_count: 'eye' }

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

  def tags(params={})
    return "-" if object.tags.blank?
    object.tags.map do |tag|
      if params[:tag_id].eql?(tag.id.to_s)
        h.link_to tag.name, h.filtered_entries_path(tag_id: nil), class: 'text-primary'
      else
        h.link_to tag.name, h.filtered_entries_path(tag_id: tag.id)
      end
    end.join(', ').html_safe
  end

  def status_with_date(threshold=nil)
    date = case object.status
    when "published"
      object.published_at
    else
      object.updated_at
    end
    threshold = 30.days.ago if threshold.nil?
    if date < threshold
      h.t(status, scope: 'activerecord.attributes.blog/contents/post.decorator.statuses.with_date', date: date.strftime(date.year.eql?(Time.now.year) ? short_date_format_without_year : short_date_format))
    else
      h.t(status, scope: 'activerecord.attributes.blog/contents/post.decorator.statuses.with_date_in_words', date: h.time_ago_in_words(date))
    end
  end

  def status
    if object.published?
      object.published_at > Time.now ? :scheduled : :published
    elsif object.submitted?
      :submitted
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

  def excerpt(length=150)
    h.truncate object.sanitized_body, length: length, separator: /\s/, omission: ' ...'
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

  def public_url
    "#{permalink_prefix}#{object.slug}"
  end

  def self.user_icon(user_type)
    option USER_TYPE_ICON_OPTIONS, user_type
  end

  def self.status_icon(status)
    option STATUS_ICON_OPTIONS, status
  end


end
