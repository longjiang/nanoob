class Dashboard::Period < ApplicationRecord
  
  enum cycle: [:daily, :weekly, :monthly, :yearly]
  
  def duration
    case cycle.to_sym
    when :daily
      1.day
    when :weekly
      1.week
    when :monthly
      1.month
    when :yearly
      1.year
    else
        0
    end
  end
  
  def output(options={}, &block)
    cycles_count.downto(1).each do |i|
      starts = eval("Time.zone.now.#{starts_at}") + (i-1) * duration
      item = Dashboard::PeriodItem.new(options[:collection], starts, duration)      
      yield(starts.strftime("%d/%m/%y"), item.count, item.slide)
    end
  end
  
  private
  
  def method_name
    
  end
end
