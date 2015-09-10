class Ability
  include CanCan::Ability

  def initialize(team_user)
    # Order matters!
    # Greater roles inherit lower permissions
    user = team_user.user

    if team_user.role? :user
      # User can update/view themselves
      can :read, User, id: user.id
      can :update, User, id: user.id

      # Can view projects they are a member of
      can :read, Project, id: user.projects.pluck(:id)

      can :create, Project
      can :create, Story
      can :create, Task
      can :create, Attachment

      # Can archive stories they are a member of
      can :destroy, Story, project_id: user.projects.pluck(:id)

      # Can update objects they own
      can :update, Project, owner_id: user.id
      can :update, Story, owner_id: user.id
      can :update, Task, owner_id: user.id
      can :update, Attachment, owner_id: user.id
      can :update, Comment, owner_id: user.id
      can :destroy, Comment, owner_id: user.id
      can :destroy, Project, owner_id: user.id
    end

    if team_user.role? :admin
      can :manage, Project
      can :read, User
      can :assign_roles, User

      # Can edit users below their role
      can :update, User do |user|
        user.team_users.find_by!(team_id: team_user.team_id).role.in? team_user.assignable_roles[0...-1]
      end
    end

    if team_user.role? :owner
      # Can haz all the things
      can :manage, :all
    end
  end
end
