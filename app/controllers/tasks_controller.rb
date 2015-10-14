class TasksController < ApplicationController

  def index
    story = Story.friendly.find(params[:story_id])
    tasks = story.tasks.includes(:assignment, :story, :project)

    render json: tasks, status: 200
  end

  def create
    @task = Task.new(
      story: Story.friendly.find(params[:story_id]),
      owner: current_user,
      label: task_params[:label],
      assigned_to: task_params[:assignment].to_i,
      due_at: task_params[:due_at].to_date
    )

    authorize! :create, @task

    if @task.save
      notify(@task, %w(created mentioned))
      respond_to do |format|
        format.html { redirect_to :back, notice: "Your task has been added" }
        format.json { render json: @task, status: 200 }
      end
    else
      respond_to do |format|
        format.html do
          flash[:error] = get_first_error(@task)
          redirect_to :back
        end
        format.json { render json: @task.errors, status: 400 }
      end

    end
  end

  def update
    @task = Task.find(params[:id])
    authorize! :read, @task.story.project

    # just updating the completed field
    if params[:completed].present?
      update_completion_status(@task)
    else
      update_details(@task)
    end
  end

  def update_order
    project = Project.friendly.find(params[:project_id])
    authorize! :read, project
    story = project.stories.friendly.find(params[:story_id])

    params[:order].each_with_index do |task_id, i|
      story.tasks.find(task_id.to_i).update(order: i + 1)
    end

    render nothing: true
  end

  def destroy
    task = Task.find(params[:id])
    authorize! :read, task.story.project

    task.destroy

    redirect_to :back, notice: "Task has been deleted"
  end

private

  def task_params
    params.require(:task).permit(:label, :assignment, :due_at)
  end

  def update_completion_status(task)
    task.update_completion_status(params[:completed], current_user)
    notify(@task, 'completed') if params[:completed]

    render json: task, status: 200
  end

  def update_details(task)
    originally_assigned_to = task.assigned_to
    task.label = task_params[:label]
    task.assigned_to = task_params[:assignment].to_i
    task.due_at = task_params[:due_at].to_date

    if task.save
      # assignment has been updated, and it wasn't to the current user
      if assignment_updated?(task, originally_assigned_to)
        notify(@task, 'assigned')
      end

      render json: task, status: 200
    else
      render json: { result: false, error: task.errors.full_messages.first }, status: 400
    end
  end

  def assignment_updated?(task, originally_assigned_to)
    return false unless task.assignment.present?

    (task.assigned_to != originally_assigned_to) && (task.assigned_to != current_user.id)
  end

end
