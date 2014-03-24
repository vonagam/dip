g.make.hold = (who)->
  position = who.parent()

  who.data 'order',
    type: 'hold'
    position: position

  position.data('targeting')[position.attr('id')] = who
