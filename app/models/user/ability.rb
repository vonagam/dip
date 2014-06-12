class Ability
  include CanCan::Ability

  def initialize( user )
    user ||= User.new

    can :start, Game, creator_id: user.id, status: 'waiting'

    can :destroy, Game do |game|
      if game.creator_id == user.id
        case game.status
        when 'waiting' then true
        when 'started' then game.time_mode == 'manual' || game.is_left?
        end
      end
    end

    can :create, Message do |message|
      message.game.status == 'waiting' || 
      participate_in( message.game, user )
    end

    can :create, Order do |order|
      order.game.status == 'started' && 
      participate_in( order.game, user )
    end

    can [:create, :update, :delete], Side do |side|
      side.game.status == 'waiting' && 
      side.user_id == user.id  && 
      side.game.creator_id != user.id
    end


    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/bryanrite/cancancan/wiki/Defining-Abilities
  end

  protected

  def participate_in( game, user )
    game.side_of( user ).not_nil?
  end
end
