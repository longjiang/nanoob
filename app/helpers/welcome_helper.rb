module WelcomeHelper
  
  def period_of_day
    
    current_time = Time.now
    beginning_of_day  = current_time.beginning_of_day
    noon              = current_time.middle_of_day
    five_pm           = current_time.change(:hour => 17 )
    eight_pm          = current_time.change(:hour => 20 )
    end_of_day        = current_time.end_of_day
    
    message = case current_time
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
