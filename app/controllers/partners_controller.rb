class PartnersController < CrudController
  self.permitted_attrs  = [:title, :category, :url, :contact_name, :contact_email, :webform_url]
  self.filtering_params = [ :category, :starts_with, :contact, :recent, :inactive, :owner ]
  self.sortable_attrs   = [ :title, :category, :contact_name, :created_at ]
end
