class Partner::RequestDecorator < ApplicationRecordDecorator
  delegate_all
  
  def name
    "#{h.i(self.class.icon)} Request ##{object.id}".html_safe
  end
  
  
  def state_updated_at
    if object.state_updated_at < 30.days.ago
      object.state_updated_at.strftime(short_date_format)
    else
      h.time_ago_in_words(object.state_updated_at)
    end
  end
  
  def subject(size=:xxl)
    return object.subject if size.eql?(:xxl)
    length = case size
    when :xs
      10
    when :sm
      20
    when :md
      30
    when :lg
      40
    else
      60
    end  
    h.truncate(object.subject, length: length, separator: " ")
  end
  
  def i_channel
    "#{h.i(channel_icon)} #{object.channel.humanize}".html_safe
  end
  
  def channel_icon
    case object.channel
    when 'email'
      'envelope'
    when 'webform'
      'wpforms'
    else
      'exclamation-triangle'
    end
  end
  
  def i_state
    "#{h.i(state_icon)} #{object.state.humanize}".html_safe
  end
  
  def state_icon
    case object.state
    when 'draft'
      'sticky-note-o'
    when 'sent'
      'send-o'
    when 'canceled'
      'times-circle-o'
    when 'paid'
      'euro'
    when 'rejected'
      'frown-o'
    when 'in_progress'
      ['spinner','pulse']
    when 'accepted'
      'thumbs-up'
    when 'submitted'
      'file-word-o'
    when 'published'
      'flag-checkered'
    else
      'exclamation-triangle'
    end
  end
  
  def state_color
    case object.state
    when 'draft'
      'muted'
    when 'sent'
      ''
    when 'canceled'
      'info'
    when 'paid'
      'warning'
    when 'rejected'
      'danger'
    when 'in_progress'
      ''
    when 'accepted'
      'success'
    when 'submitted'
      ''
    when 'published'
      'success'
    else
      'muted'
    end
  end

  def self.icon
    'file-text'
  end

end
