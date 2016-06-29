class Partner::BacklinksController < CrudController
  self.permitted_attrs = [:partner_id, :business_id, :partner_request_id, :user_id, :referrer, :anchor, :link]
end
