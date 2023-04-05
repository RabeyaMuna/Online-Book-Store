class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, [Book, Author, Genre]
    return if user.blank?

    if user.admin?
      can :manage, :all

      cannot :update, User
      can :update, User, id: user.id
    else
      can %i(show update), User, id: user.id
    end
  end
end
