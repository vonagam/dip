json.extract! @game, :id, :status

json.sides @game.sides do |side|
  json.extract! side, :power, :alive, :orderable
  json.user side.user.login

  if @side == side
    json.current true
  end
end

json.states @game.states do |state|
  json.extract! state, :id, :date, :type, :data, :end_at

  orders =
  if state != @state
    state.resulted_orders
  elsif @side && order = @game.order_of(@side)
    { @side.power => order.data }
  else
    nil
  end
    
  json.orders orders
end

select = [{ public: true }]
select.push( { to: @side.power }, { from: @side.power } )if @side
messages = @game.messages.or(*select).desc(:created_at).limit(50).to_a

json.messages messages do |message|
  json.extract! message, :from, :to, :public, :created_at, :public, :text
end
