module Api
  module V1
    class TasksController < BaseController
      before_action :set_story, only: [:index, :create, :destroy_completed, :update_order]

      resource_description do
        formats ["json"]
      end

      def_param_group :task do
        param :task, Hash, desc: "Task info" do
          param :label, String, desc: "Task description", required: true
          param :assigned_to, Integer, desc: "User to assign the task to", required: false
          param :due_at, DateTime, desc: "Schedule a time for the task to be due", required: false
          param :completed, [true, false], desc: "Whether the task is complete or not", required: false
        end
      end

      api! "Fetch all tasks"
      param :story_id, String, desc: "Story ID or slug", required: true
      def index
        tasks = @story.tasks.includes(:assignment, :story, :project)
        render json: tasks
      end

      api! "Fetch a single task"
      def show
        task = Task.includes(:assignment, :story, :project).find(params[:id])
        render json: task
      end

      api! "Create new task"
      param :story_id, String, desc: "Story ID or slug", required: true
      param_group :task
      def create
        @task = @story.tasks.build(task_params.merge(owner: current_user))

        authorize! :create, @task

        if @task.save
          notify(@task, %w(created mentioned))
          render json: @task, status: 201
        else
          render_errors(@task)
        end
      end

      api! "Update a task"
      param_group :task
      def update
        task = Task.find(params[:id])

        originally_assigned_to = task.assigned_to

        if task_params[:completed]
          task.completer = current_user
          task.completed_on = Time.zone.now
        end

        if task.update(task_params)
          if assignment_updated?(task, originally_assigned_to)
            # assignment has been updated, and it wasn't to the current user
            notify(task, 'assigned')
          end
          notify(task, 'completed') if task_params[:completed]

          render json: task, status: 200
        else
          render_errors(task)
        end
      end

      api! "Update task order"
      param :order, Array, desc: "Task IDs in new order", required: true
      def update_order
        params[:order].each_with_index do |task_id, i|
          @story.tasks.find(task_id.to_i).update(order: i + 1)
        end

        render nothing: true, status: 204
      end

      api! "Delete task"
      def destroy
        task = Task.find(params[:id])
        task.destroy

        render nothing: true, status: 204
      end

      api! "Delete all completed tasks"
      def destroy_completed
        @story.tasks.complete.destroy_all

        render nothing: true, status: 204
      end

      private

      def set_story
        @story = Story.friendly.find(params[:story_id])
        project = @story.project

        authorize! :read, project
      end

      def task_params
        task = params.require(:task).permit(:label, :assigned_to, :due_at, :completed)
        task[:assigned_to] = task[:assigned_to].to_i
        task[:due_at] = String(task[:due_at]).to_date
        task
      end

      def assignment_updated?(task, originally_assigned_to)
        return false unless task.assignment.present?

        (task.assigned_to != originally_assigned_to) && (task.assigned_to != current_user.id)
      end
    end
  end
end
