class Partner::RequestDecorator < ApplicationRecordDecorator
  delegate_all
  
  SUBJECT_LENGTH_OPTIONS  = {default: 60, xs: 10, sm: 20, md: 30, lg: 40}
  CHANNEL_ICON_OPTIONS    = {default: 'exclamation-triangle', email: 'envelope', webform: 'wpforms'}
  STATE_ICON_OPTIONS      = {default:'exclamation-triangle', draft:'sticky-note-o', sent:'send-o', canceled:'times-circle-o', paying:'money', paid:'euro' ,rejected:'frown-o', in_progress:['spinner','pulse'], accepted:'thumbs-up', submitted:'file-word-o', published:'flag-checkered'}
  STATE_COLOR_OPTIONS     = {default:'muted', draft:'muted', sent:'', canceled:'info', paying:'warning', paid:'' ,rejected:'danger', in_progress:'', accepted:'success', submitted:'', published:'success'}
  
  def name
    "#{h.i(self.class.icon)} Request ##{object.id}".html_safe
  end
  
  def state_updated_at
    time_ago_in_words_or_date object.state_updated_at
  end
  
  def sent_at
    return if object.sent_at.nil?
    if object.sent_at < 30.days.ago
      object.sent_at.strftime(short_date_format)
    else
      h.time_ago_in_words(object.sent_at)
    end
  end
  
  def subject(size=:xxl)
    return object.subject if size.eql?(:xxl)
    h.truncate(object.subject, length: subject_length(size), separator: ' ')
  end
  
  def i_channel
    "#{h.i(channel_icon)} #{object.channel.humanize}".html_safe
  end
  
  def i_state
    "#{h.i(state_icon)} #{object.state.humanize}".html_safe
  end
  
  def subject_length(size)
    option :subject_length, size
  end
  
  def channel_icon
    option :channel_icon, object.channel
  end
  
  def state_icon
    option :state_icon, object.state
  end
  
  def state_color
   option :state_color, object.state
  end
  
  def body_xs_if_error_class
    "has-error" if object.errors && object.errors[:body_xs].present?
  end

  def self.icon
    'envelope'
  end

end
