module ApplicationHelper
  def n(val)
    val.to_i == val ? val.to_i : val
  end
end
