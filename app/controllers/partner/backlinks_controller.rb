class Partner::BacklinksController < CrudController
  self.permitted_attrs = [:partner_id, :business_id, :request_id, :url, :term, :link]
end
