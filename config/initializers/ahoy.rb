class Ahoy::Store < Ahoy::Stores::ActiveRecordTokenStore
  # customize here
  def track_visit(options)
    super(options) do |visit|
      visit.business_website_id = Business::Website.find_by_request(request).id
    end
  end
  def track_event(name, properties, options)
    super(name, properties, options) do |event|
      event.business_website_id = Business::Website.find_by_request(request).id
    end
  end
end
