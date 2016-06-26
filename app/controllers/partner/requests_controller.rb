class Partner::RequestsController < CrudController
  self.permitted_attrs = [:partner_id, :business_id, :subject, :body, :channel, :sent_at, :state, :owner_id, :updater_id]
end
