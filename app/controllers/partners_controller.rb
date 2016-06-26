class PartnersController < CrudController
  self.permitted_attrs = [:title, :category, :url, :contact_name, :contact_email, :webform_url]
end
