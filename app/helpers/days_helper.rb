module DaysHelper
  def date_link(date)
    link_to month(date), display_month_path(:month => date.month, :year => date.year), :remote => true
  end

  def eligible_date(num_date)
    date  = number_to_date(num_date[:month], num_date[:year])
    range = month_viewing_range(date)
    return false unless date > Date.today

    number_of_registered_days = user.days.where(:date => range).count
    range.count != number_of_registered_days
  end

  def fill_dates_link(num_date)
    link_to "Fill Dates", fill_dates_path(:month => num_date[:month], :year => num_date[:year]), :remote => true
  end

  def ordinal(day)
    "#{day.day}<sup>#{day.day.ordinalize[-2, 2]}</sup>".html_safe
  end

  def week_headings
    %w( Mon Tue Wed Thu Fri Sat Sun )
  end

  def get_month_and_year
    { :month => Date.today.month, :year => Date.today.year }
  end

  def prev_month(month, year)
    number_to_date(month, year) - 1.month
  end

  def next_month(month, year)
    number_to_date(month, year) + 1.month
  end

  def month(date)
    date.strftime("%B")
  end

  def month_year(date)
    date.strftime("%B %Y")
  end

  def number_to_date(month, year)
    Date.parse("#{year}-#{month}-1")
  end

  def month_viewing_range(date)
    start_date = date.beginning_of_month.beginning_of_week
    end_date   = date.end_of_month.end_of_week
    start_date..end_date
  end

  def month_viewing_range_in_weeks(month, year)
    date = number_to_date(month, year)
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
