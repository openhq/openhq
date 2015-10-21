module Api
  module V1
    class TasksController < BaseController
      before_action :set_story

      def index
        tasks = @story.tasks.includes(:assignment, :story, :project)
        render json: tasks
      end

      def show
        task = @story.tasks.includes(:assignment, :story, :project).find(params[:id])
        render json: task
      end

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

      def update
        task = @story.tasks.find(params[:id])

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

      def update_order
        params[:order].each_with_index do |task_id, i|
          @story.tasks.find(task_id.to_i).update(order: i + 1)
        end

        render nothing: true, status: 204
      end

      def destroy
        task = @story.tasks.find(params[:id])
        task.destroy

        render nothing: true, status: 204
      end

      def destroy_completed
        @story.tasks.complete.destroy_all

        render nothing: true, status: 204
      end

      private

      def set_story
        @project = current_team.projects.friendly.find(params[:project_id])
        @story = @project.stories.friendly.find(params[:story_id])

        authorize! :read, @project
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
