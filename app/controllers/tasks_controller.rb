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
    @task = Task.find(params[:id])

    @task.update(
      completed: params[:completed],
      completed_by: params[:completed] ? current_user.id : nil,
      completed_on: params[:completed] ? Time.zone.now : nil
    )

    render json: @task
  end

private

  def task_params
    params.require(:task).permit(:label)
  end

end