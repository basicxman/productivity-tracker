class TasksController < ApplicationController
  respond_to :js, :except => [:index]

  def index
    user.fill_future
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

  def update
    @task = Task.find(params[:id].to_i)
    @task.update_attributes(params[:task])
    @point = @task.add_points(params[:task][:custom_points].to_f)
    if @task.save
      flash[:notice] = "Updated task."
    else
      flash[:notice] = "Unable to update task."
    end
  end

  def destroy
    @task = Task.find(params[:id].to_i)
    @task.destroy
  end

  def colour
    @task = Task.find(params[:id].to_i)
    @task.update_attribute(:colour, params[:colour])
  end
end
