class StoriesController < ApplicationController
  before_action :set_project
  before_action :set_story, only: [:show, :edit, :update]

  def show
    fresh_when last_modified: @story.updated_at
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

  def edit
    authorize! :update, @story
  end

  def update
    authorize! :update, @story

    if @story.update(story_params)
      redirect_to project_story_path(@story.project, @story), notice: "Story updated"
    else
      render :edit
    end
  end

private

  def set_story
    @story = Story.friendly.find(params[:id])
  end

  def set_project
    @project = Project.friendly.find(params[:project_id])
    authorize! :read, @project
  end

  def story_params
    params.require(:story).permit(:name, :description)
  end

end
