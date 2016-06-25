module ApplicationHelper
  
  def i(icon, *options)
    options << icon
    content_tag(:i, '', class: "fa fa-#{options.join(' fa-')}")
  end
  
  def th(key, options = {})
    t(key,options).humanize
  end
  
  def tm(model, options = {})
    th "activerecord.models.#{model.to_s}", options.merge(count: 1)
  end
  
end
