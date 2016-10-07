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
  
  def han(model, attribute, options = {})
    options[:count] = 1 if options[:count] && options[:count].eql?(0)
    model.to_s.classify.constantize.send('human_attribute_name', attribute, options)
  end
  
  def hen(model, attribute, value)
    model.to_s.classify.constantize.decorator_class.send('human_enum_name', attribute, value)
  end
  
  def has_role? role
    current_user.has_role? role
  end
  
  def is_admin?
    has_role? :admin
  end
  
  def fluid_text(object, method)
    capture_haml do
      haml_tag :span, object.send(method, :xs), class: 'hidden-sm-up'
      haml_tag :span, object.send(method, :sm), class: 'hidden-md-up hidden-xs-down'
      haml_tag :span, object.send(method, :md), class: 'hidden-lg-up hidden-sm-down'
      haml_tag :span, object.send(method, :lg), class: 'hidden-xl-up hidden-md-down'
      haml_tag :span, object.send(method, :xl), class: 'hidden-lg-down'
    end.html_safe
  end
  
end
