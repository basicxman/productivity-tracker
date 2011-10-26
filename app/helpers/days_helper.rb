module DaysHelper
  def ordinal(day)
    "#{day.day}<sup>#{day.day.ordinalize[-2, 2]}</sup>".html_safe
  end

  def week_headings
    %w( Sun Mon Tue Wed Thu Fri Sat )
  end

  def month
    Date.today.month
  end

  def month_viewing_range(date)
    start_date = date.beginning_of_month.beginning_of_week
    end_date   = date.end_of_month.end_of_week
    start_date..end_date
  end

  def month_viewing_range_in_weeks(month_num)
    date = Date.parse("#{Date.today.year}-#{month_num}-1")
    month_viewing_range(date).to_a.in_groups_of(7)
  end

  def get_data_for_day(day)
    data = {
      :cell => "",
      :points => 0,
      :quota_input => "0"
    }
    day = user.days.find_by_date(day)
    unless day.nil?
      data[:cell] = "id='#{dom_id(day)}'"
      data[:points] = n day.current_points
      data[:quota_input] = if day.date >= Date.today
        text_field_tag :quota, n(day.quota), :class => "day-quota"
      else
        n(day.quota)
      end
    end
    data
  end
end
