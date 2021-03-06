class User < ActiveRecord::Base
  has_many :tasks, :dependent => :destroy
  has_many :days,  :dependent => :destroy
  has_secure_password

  validates_uniqueness_of :email

  after_create :fill_future

  def fill_future(date = Date.today)
    date.upto(date.end_of_month.end_of_week) do |day|
      self.days << Day.create(:date => day, :quota => 0) if self.days.find_by_date(day).nil?
    end
  end

  def scheduling_days
    self.days.where("date > ? AND date <= ?", Date.today - 31.days, Date.today + 31.days)
  end

  def quota_window
    self.days.where("date > ? AND date <= ?", Date.today - 31.days, Date.today)
  end

  def required_points
    self.quota_window.sum("quota")
  end

  def achieved_points
    Point.where(:day_id => quota_window).sum("value")
  end

  def current_quota
    required_points - achieved_points
  end

  # The Rolling Quota is the remaining or excesss quota from the past 31 days
  # in addition to the current days quota.
  def rolling_quota
    points = required_points
    window = self.days.where("date > ? and date < ?", Date.today - 31.days, Date.today)
    points - Point.where(:day_id => window).sum("value")
  end

  def todays_quota
    self.days.find_by_date(Date.today).quota
  end

  def todays_points
    self.days.find_by_date(Date.today).points.sum("value")
  end

  def chart
    total_data = []
    tasks_data = {}
    tasks = self.tasks
    tasks.each { |t| tasks_data[t.name] = { :data => [], :color => "#39f" } }
    none_discovered = true
    (Date.today - 31.days).upto(Date.today) do |date|
      day = Day.find(:first, :conditions => { :date => date, :user_id => self.id })
      next if day.nil? and none_discovered
      none_discovered = false

      graph_date = date.to_datetime.to_i * 1000
      total_data << [graph_date, day ? day.points.sum("value") : 0]
      tasks.each do |task|
        tasks_data[task.name][:color] = task.base_colour
        point_value = day ? Point.where(:task_id => task.id, :day_id => day.id).sum("value") : 0
        tasks_data[task.name][:data] << [graph_date, point_value]
      end
    end

    tasks_data = tasks_data.inject([]) do |data_arr, pair|
      data_arr + [{ :label => pair[0] }.merge(pair[1])]
    end
    tasks_data + [ { :color => "#39f", :data => total_data, :label => "Total" } ]
  end
end
