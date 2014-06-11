json.extract! @game, 
  :id, 
  :time_mode,
  :chat_mode,
  :status,
  :powers_is_random,
  :is_public

json.chat_is_public @game.chat_is_public?

json.sides @game.sides do |side|
  json.extract! side, :power, :alive, :orderable
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
    { @side.power => order.data }
  end
    
  json.orders orders
end

select = [{ public: true }]
select.push( { to: @side.power }, { from: @side.power } ) if @side
messages = @game.messages.or(*select).desc(:created_at).limit(50).to_a

json.messages messages do |message|
  json.extract! message, :from, :to, :created_at, :public, :text
end

if user_signed_in?
  json.login current_user.login
end
