class Dashboard::PeriodItem
  
  attr_accessor :collection, :starts_at, :ends_at, :duration, :count
  
  def initialize(collection, starts_at, duration)
    @collection = collection
    @duration   = duration
    @starts_at  = starts_at
    @ends_at    = starts_at + duration
  end
  
  def count
    collection.after(starts_at).before(ends_at).count
  end
  
  def slide
    @ends_at    = starts_at
    @starts_at  = starts_at - duration
    count
  end
  
end