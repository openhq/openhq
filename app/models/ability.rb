class Ability
  include CanCan::Ability

  def initialize(user)
    # Order matters!
    # Greater roles inherit lower permissions

    if user.role? :user
      # User can update/view themselves
      can :read, User, id: user.id
      can :update, User, id: user.id

      can :create, Story
      can :create, Task
      can :create, Attachment

      # Can update objects they own
      can :update, Story, owner_id: user.id
      can :update, Task, owner_id: user.id
      can :update, Attachment, owner_id: user.id
    end

    if user.role? :admin
      can :manage, Project
      can :read, User
      can :assign_roles, User

      # Can edit users below their role
      can :update, User, role: user.assignable_roles[0...-1]
    end

    if user.role? :owner
      # Can haz all the things
      can :manage, :all
    end

  end
end
