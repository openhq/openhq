class ProjectPresenter < BasePresenter
  presents :project

  def story
    nil
  end

  def notifiable_users(action_performed)
    case action_performed
    when "created"
      project.users.where('user_id != ?', project.owner_id)
    end
  end

end