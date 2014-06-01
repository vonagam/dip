class view.Participation
  constructor: ( @game )->
    @view = g.page.find '.participation.j_component'

  update: ->
    visible = @game.status == 'waiting'

    @view.toggle visible

    #TODO Table

    return
