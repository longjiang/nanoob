class Business::WebsitesController < CrudController
  
  self.permitted_attrs = [:platform, :url, :business_id]
  
  before_action :find_business
  
  def index
    if @business
      @websites = @business.websites
    else
      super
    end
  end
  
  private
  
  def find_business
    @business = if params[:business_id].present?
      Business.find_by_id(params[:business_id]) 
    elsif has_model_params?
      Business.find_by_id(model_params[:business_id]) 
    elsif @website && !@website.new_record?
      @website.business 
    end
  end
  
end
