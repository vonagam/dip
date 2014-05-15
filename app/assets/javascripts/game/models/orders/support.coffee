class model.Order.Support extends model.Order.Base
  constructor: (unit, data)->
    super
    @type = 'Support'
    @from = data.from 
    @to = data.to

  create_visualization: ->
    supporter = @unit.coords
    from = @unit.areas( @from ).unit.coords
    to = @unit.areas( @to ).coords()
    
    middle = new Vector
      x: (from.x*1.2+to.x*0.8)/2
      y: (from.y*1.2+to.y*0.8)/2

    vec = middle.dif( supporter ).norm()

    supporter = supporter.sum( vec.mult(8) )

    if from == to
      middle.sub( vec.mult(12) )
    
    line = document.createElementNS 'http://www.w3.org/2000/svg', 'path'
    
    line = $ line
    
    line.attr 
      'd': 'M'+supporter.x+','+supporter.y+'L'+middle.x+','+middle.y
      'class': "support #{@unit.power.name}"

    return line

  to_json: ->
    j = super
    j['from'] = @from
    j['to'] = @to
    return j
