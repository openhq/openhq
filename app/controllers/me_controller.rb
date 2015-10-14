class MeController < ApplicationController
    def index
        @tasks = current_user.tasks.includes(:project, :story)
    end
end