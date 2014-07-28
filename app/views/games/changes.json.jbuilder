json.game do
  json.extract! @game, :status

  json.partial! 'sides/index', sides: @game.sides
  json.partial! 'states/index', states: @game.states

  json.orders @side && order = @game.order_of(@side)
end
