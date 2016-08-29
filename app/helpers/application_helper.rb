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
  
  def tmp(model, options = {})
    th "activerecord.models.#{model.to_s}", options.merge(count: 2)
  end
  
  def han(model, attribute)
    model.to_s.classify.constantize.send('human_attribute_name', attribute)
  end
  
  def hen(model, attribute, value)
    model.to_s.classify.constantize.decorator_class.send('human_enum_name', attribute, value)
  end
  
end
