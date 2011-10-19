module TasksHelper
  def points_button(task, value, css_class)
    if value < 0
      text, text_class = "-", "negative"
    else
      text, text_class = "+", "positive"
    end
    content_tag :div, :class => "pill-button #{css_class} #{text_class}" do
      link_to text, points_task_path(task, :value => value), :method => :post, :remote => true
    end
  end
end
