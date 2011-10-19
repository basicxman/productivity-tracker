class TasksController < ApplicationController
  respond_to :js, :except => [:index]

  def index
    @tasks = user.tasks
    @new_task = Task.new
  end

  def points
    @task = Task.find(params[:id])
    @value = params[:value].to_f
    @point = @task.add_points(@value)
    render :nothing => true if @point.nil?
  end

  def create
    @task = Task.new(params[:task])
    if @task.save
      user.tasks << @task
      flash[:notice] = "Added task."
    else
      flash[:notice] = "Unable to create task."
    end
  end
end
