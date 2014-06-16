json.extract! @game, 
  :id, 
  :time_mode,
  :chat_mode,
  :status,
  :powers_is_random,
  :is_public

json.chat_is_public @game.chat_is_public?

if user_signed_in?
  json.login current_user.login
end

json.sides @game.sides do |side|
  json.extract! side, :power, :name, :status, :orderable
  json.user side.user.login

  json.user_side true if @side == side

  json.creator true if @game.creator == side.user
end

json.states @game.states do |state|
  json.extract! state, :id, :date, :type, :data, :end_at

  orders =
  if state != @state
    state.resulted_orders
  elsif @side && order = @game.order_of(@side)
    order.data
  end
    
  json.orders orders
end
