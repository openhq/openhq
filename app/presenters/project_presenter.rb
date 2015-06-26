class ProjectPresenter < BasePresenter
  presents :project

  def story
    nil
  end

  def notifiable_users(action_performed)
    project.users.where('user_id != ?', project.owner.id)
  end

end