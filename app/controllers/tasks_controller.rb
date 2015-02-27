class TasksController < ApplicationController

  def create
    @task = Task.new(
      story: Story.friendly.find(params[:story_id]),
      owner: current_user,
      label: task_params[:label],
    )

    if @task.save
      redirect_to :back, notice: "Your task has been added"
    else
      flash[:error] = get_first_error(@task)
      redirect_to :back
    end
  end

  def update
    task = Task.find(params[:id])

    task.completed = params[:completed]
    task.completed_by = params[:completed] ? current_user.id : nil
    task.completed_on = params[:completed] ? Time.zone.now : nil

    if task.save
      render json: { result: true, task: task }
    else
      render json: { result: false }
    end
  end

private

  def task_params
    params.require(:task).permit(:label)
  end

end