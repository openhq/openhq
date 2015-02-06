class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = current_user.projects
  end

  def show
    authorize! :read, @project
  end

  def new
    @project = Project.new
    authorize! :create, @project
  end

  def create
    @project = current_user.projects.build(project_params)
    authorize! :create, @project

    if @project.save
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
  end

  def destroy
    authorize! :destroy, @project
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name)
  end

end
