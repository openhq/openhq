class MeController < ApplicationController
    def index
        @tasks = current_user.tasks.incomplete.includes(:project, :story)
    end
end