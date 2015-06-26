class ProjectPresenter < BasePresenter
  presents :project

  # NOTIFICATIONS
  def story
    nil
  end

  def notifiable_users
    project.users.where('user_id != ?', project.owner.id)
  end

end