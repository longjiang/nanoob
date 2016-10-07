module CrudHelper
  
  def sortable_attr_name(attr)
    "#{Sortable::PREFIX}#{attr.to_s}"
  end
  
  def filtered_entries_path(filter)
    method        = "#{controller_path.gsub('/','_')}_path"
    ctrl          = controller
    permit_params = ctrl.filtering_params + ctrl.sortable_attrs.map {|_| sortable_attr_name(_).to_sym}
    send(method, params.slice(*permit_params).permit(*permit_params).merge(filter))
  end
  
  def sorted_entries_path(order)
    filtered_entries_path(order.map{|k,v| ["#{Sortable::PREFIX}#{k}".to_sym,v]}.to_h)
  end 
  
  def desc?(attr)
    params[sortable_attr_name(attr)].eql?('desc')
  end
  
  def asc?(attr) 
    params[sortable_attr_name(attr)].eql?('asc')
  end
  
end
  
