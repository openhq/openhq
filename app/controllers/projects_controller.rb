class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = current_user.projects
    @project = Project.new
  end

  def show
    authorize! :read, @project

    fresh_when last_modified: @project.updated_at

    @story = Story.new
  end

  def new
    @project = Project.new
    authorize! :create, @project
  end

  def create
    @project = current_user.created_projects.build(project_params)
    authorize! :create, @project

    if @project.save
      NotificationService.new(@project, 'created').notify
      @project.users << current_user
      redirect_to project_path(@project), notice: "Project created"
    else
      render :new
    end
  end

  def edit
    authorize! :update, @project
  end

  def update
    authorize! :update, @project

    if @project.update(project_params)
      # TODO bugfix:
      # after updating a project params[:user_ids] won’t include
      # the current_user anymore
      @project.users << current_user
      redirect_to @project, notice: "Project saved"
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @project

    @project.destroy
    redirect_to projects_path, notice: "#{@project.name} has been archived"
  end

  def archived
    @projects = current_user.projects.only_deleted
  end

  def restore
    @project = current_user.projects.only_deleted.friendly.find(params[:id])

    authorize! :edit, @project
    @project.restore

    redirect_to @project, notice: "#{@project.name} has been restored"
  end

  private

  def set_project
    @project = Project.friendly.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, user_ids: [])
  end

end
