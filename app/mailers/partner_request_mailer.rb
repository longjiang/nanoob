class PartnerRequestMailer < ApplicationMailer
  
  include Resque::Mailer
  
  def initial_request(params)
    params.symbolize_keys!
    @request = Partner::Request.find_by_id(params[:request_id])
    @partner = @request.partner
    mail(to: @partner.contact_email, subject: @request.subject)
  end
end
