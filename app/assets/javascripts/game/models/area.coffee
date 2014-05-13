class model.Area
  constructor: ( @map, @name, data )->
    @type = data['type']

    view = $('#'+@name)
    views = { 'xc': view }
    view.data 'model', this

    view.children('[id]').each ->
      q = $ this
      sub = q.attr('id').split('_')[1]
      views[sub] = q
      return

    @views = views

    @targeting = {}

    #@unit
    #@dislodged
    #@embattled

  coords: ->
    @views['xc'].data 'coords'

  embattled: (bool) ->
    if bool
      @is_embattled = true

      if !@unit
        coords = @coords()

        star = document.createElementNS 'http://www.w3.org/2000/svg', 'use'
        star.setAttributeNS 'http://www.w3.org/1999/xlink', 'href', '#embattled'

        star = $(star)

        star.attr
          'class': "embattled"
          'transform': "translate(#{coords.x},#{coords.y})"
        
        star.appendTo @views.xc
    else
      @views.xc.find('.embattled').remove()
      delete this['is_embattled']
    return
