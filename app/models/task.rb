class Task < ActiveRecord::Base
  belongs_to :user
  has_many :points, :dependent => :destroy

  validates_numericality_of :required_points, :greater_than => 0

  attr_accessor :custom_points

  def iterative_deduction(value, points = [])
    return points if value == 0

    point_id = self.points.joins(:day).reorder("date DESC").where("value > 0").limit(1)
    return points if point_id.nil? or point_id.length == 0

    point = Point.find(point_id.first.id)
    temp = point.value

    if temp - value < 0
      point.update_attribute(:value, 0)
      return iterative_deduction(value - temp, points + [point])
    else
      point.update_attribute(:value, temp - value)
      return points + [point]
    end
  end

  def add_points(value)
    point = self.points.find_or_create_by_day_id(user.days.find_by_date(Date.today).id)
    point.value ||= 0
    if value < 0
      point.save
      return iterative_deduction(-value)
    end

    temp = self.points.sum("value") + value
    unless (value < 0 and temp < 0) or (value > 0 and temp > self.required_points)
      point.value += value
      point.save
      return point
    end
  end

  def achieved_points
    Point.where(:task_id => self.id).sum("value")
  end

  def todays_points
    day = Day.find(:first, :conditions => { :user_id => user.id, :date => Date.today })
    Point.find(:first, :conditions => { :task_id => self.id, :day_id => day.id }).value
  end

  def colour_class
    self.colour || DEFAULT_COLOUR_CLASS
  end

  def base_colour
    index = self.colour[1..-1].to_i - 1
    colours = %w( #39f #f33 #9f9 #995ac4 #fff #555 #d2691e #00bfff #4682b4 )
    colours[index]
  end

  NUMBER_OF_COLOURS = 9
  DEFAULT_COLOUR_CLASS = "c1"
end
