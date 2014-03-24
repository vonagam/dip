@g.make = {}

g.make.cancel = (who)->
  order = who.data 'order'
  dislocation = who.parent().attr('id')

  return {} unless order
  
  who.data 'order', null

  if order.visual
    order.visual.remove()
  
  if order.position
    delete order.position.closest('g').data('targeting')[dislocation]

  if order.convoy
    for i in [1..order.convoy.length-2]
      fleet = order.convoy.eq(i).children '.force'
      fleet_order = fleet.data 'order'
      if fleet_order && fleet_order.type == 'convoy' && fleet_order.whom[0] == who[0]
        g.make.order 'hold', fleet 

  if order.type == 'convoy'
    g.make.order 'hold', order.whom

  if order.type == 'support'
    delete order.whom.data('order').supporters[dislocation]

  return order.supporters

g.make.order = (type, who)->
  supporters = g.make.cancel who
  g.make[type].apply(
    this
    Array.prototype.slice.call arguments, 1
  )
  who.data('order').supporters = supporters

  return if supporters.length == 0

  position_id = who.data('order').position.attr('id')

  for region, supporter of supporters
    can_continue = false

    for nei in supporter.data 'neighbours'
      if nei.split('_')[0] == position_id
        can_continue = true
        break

    if can_continue
      g.make.order 'support', supporter, who
    else
      g.make.order 'hold', supporter
