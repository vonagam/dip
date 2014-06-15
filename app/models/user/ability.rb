class Ability
  include CanCan::Ability

  def initialize( user )
    @user = user || User.new

    if @user.admin?
      can :manage, :all
    end

    can :start, Game, creator_id: @user.id, status: :waiting

    can :destroy, Game do |game|
      if he( game, :creator )
        case game.status
        when :waiting then true
        when :going then game.time_mode == 'manual' || game.is_left?
        end
      end
    end

    can :create, Message do |message|
      message.game.waiting? || 
      participate_in( message.game, user )
    end

    can :manage, Order do |order|
      order.game.going? &&
      he( order.side )
    end

    can :manage, Side do |side|
      side.game.waiting? &&
      he( side ) &&
      ne( side.game, :creator )
    end
  end

  protected

  def he( object, field = :user )
    object.send("#{field}_id") == @user.id
  end
  def ne( object, field = :user )
    !he( object, field )
  end

  def participate_in( game, user )
    game.side_of( user ).not_nil?
  end
end
