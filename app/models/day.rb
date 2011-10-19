class Day < ActiveRecord::Base
  belongs_to :user
  has_many :points

  default_scope order("date")

  def current_points
    self.points.sum("value")
  end
end
