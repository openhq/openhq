class TasksController < ApplicationController

  def create
    @task = Task.new(
      story: Story.friendly.find(params[:story_id]),
      owner: current_user,
      label: task_params[:label],
    )

    authorize! :create, @task

    if @task.save
      redirect_to :back, notice: "Your task has been added"
    else
      flash[:error] = get_first_error(@task)
      redirect_to :back
    end
  end

  def update
    @task = Task.find(params[:id])
    authorize! :update, @task

    if params[:completed].present?
      @task.completed = params[:completed]
      @task.completed_by = current_user.id
      @task.completed_on = Time.zone.now
    else
      @task.label = task_params[:label]
      @task.assigned_to = task_params[:assignment].to_i
    end

    if @task.save
      render json: { result: true, task: @task }
    else
      render json: { result: false, error: @task.errors.full_messages.first }
    end
  end

  def update_order
    story = Project.friendly.find(params[:project_id]).stories.friendly.find(params[:story_id])

    params[:order].each_with_index do |task_id, i|
      story.tasks.find(task_id.to_i).update(order: i+1)
    end

    render nothing: true
  end

  def destroy
    task = Task.find(params[:id])
    authorize! :delete, @task

    task.delete

    redirect_to :back, notice: "Task has been deleted"
  end

private

  def task_params
    params.require(:task).permit(:label, :assignment)
  end

end