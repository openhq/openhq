class StoriesController < ApplicationController
  before_action :set_project
  before_action :set_story, only: [:show, :edit, :update, :destroy]

  def show
    @attachments = @story.attachments.to_a
    @comments = @story.comments.includes(:attachments, :owner).to_a
    @collaborators = @story.collaborators.to_a
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
      notify(@story, %w(created mentioned))
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

  def destroy
    authorize! :destroy, @story

    @story.destroy
    redirect_to @story.project, notice: "#{@story.name} has been archived"
  end

  def archived
    @stories = @project.stories.only_deleted
  end

  def restore
    @story = @project.stories.only_deleted.friendly.find(params[:id])

    authorize! :edit, @story
    @story.restore

    redirect_to [@story.project, @story], notice: "#{@story.name} has been restored"
  end

private

  def set_story
    @story = Story.includes(:owner, :users).friendly.find(params[:id])
  end

  def set_project
    @project = Project.friendly.find(params[:project_id])
    authorize! :read, @project
  end

  def story_params
    params.require(:story).permit(:name, :description)
  end

end
