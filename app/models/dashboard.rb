module Dashboard
  def self.table_name_prefix
    'dashboard_'
  end
end

# class Dashboard
#
#   def initialize
#
#   end
#
#   def options(item)
#     case item
#     when :today
#       {goal: :daily, compare_to: :yesterday}
#     when :yesterday
#       {goal: :daily, compare_to: :two_days_ago}
#     when :this_week
#       {goal: :weekly, compare_to: :last_week}
#     when :last_week
#       {goal: :weekly, compare_to: :two_weeks_ago}
#     else
#       {}
#     end
#   end
#
# end
