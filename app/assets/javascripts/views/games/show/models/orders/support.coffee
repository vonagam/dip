class g.model.Order.Support extends g.model.Order.Base
  constructor: (unit, data)->
    super
    @type = 'Support'
    @from = data.from 
    @to = data.to

  create_visualization: ->
    supporter = @unit.coords
    from = @unit.areas( @from ).unit.coords
    to = @unit.areas( @to ).coords()

    vec = from.dif(supporter).norm()

    supporter = supporter.sum vec.mult 8


    if from == to
      from = from.dif vec.mult 12

      d = 'M'+supporter.to_s()+'L'+from.to_s()
    
    else
      middle = new Vector
        x: (from.x*1+to.x*1)/2
        y: (from.y*1+to.y*1)/2

      d = 'M'+supporter.to_s()+'Q'+from.to_s()+' '+middle.to_s()
    

    line = document.createElementNS 'http://www.w3.org/2000/svg', 'path'
    
    line = $ line
    
    line.attr
      d: d
      class: @view_class_name()

    return line

  to_json: ->
    j = super
    j['from'] = @from
    j['to'] = @to
    return j

  to_string: ->
    "S #{@from}#{ if @to != @from then ' -> '+@to else '' }"
