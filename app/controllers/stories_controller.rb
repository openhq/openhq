class StoriesController < ApplicationController
  before_action :set_project, only: [:new, :create]

  def show
    @story = Story.friendly.find(params[:id])
  end

  def new
    @story = Story.new
    authorize! :create, @story
  end

  def create
    @story = current_user.stories.build(story_params)
    authorize! :create, @story

    @story.project = @project
    if @story.save
      redirect_to project_story_path(@project, @story), notice: "Story created"
    else
      render :new
    end
  end

private

  def set_project
    @project = Project.friendly.find(params[:project_id])
  end

  def story_params
    params.require(:story).permit(:name, :description)
  end

end