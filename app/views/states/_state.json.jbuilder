json.extract! state, :id, :date, :type, :data, :end_at

orders =
if @game.ended? || state != @game.state
  state.resulted_orders
elsif @side && order = @game.order_of(@side)
  order.data
end
  
json.orders orders
