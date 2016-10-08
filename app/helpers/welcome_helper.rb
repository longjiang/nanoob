module WelcomeHelper
  
  def period_of_day
    
    current_time = Time.zone.now
    beginning_of_day  = current_time.beginning_of_day.to_i
    noon              = current_time.middle_of_day.to_i
    five_pm           = current_time.change(:hour => 17 ).to_i
    eight_pm          = current_time.change(:hour => 20 ).to_i
    end_of_day        = current_time.end_of_day.to_i
    
    message = case current_time.to_i
      when beginning_of_day..noon
        :morning
      when noon..five_pm
        :afternoon
      when five_pm..eight_pm
        :evening
      when eight_pm..end_of_day
        :night
      end
    
      message
  end
  
  
end
