class g.SelectingState extends klass.State

  constructor: ( hash )->
    @select_selecting = hash.selecting if hash.selecting
    @select_marking = hash.marking if hash.marking
    @select_container = hash.container if hash.container

    toggl = target: @select_selecting

    type = @select_marking.match /^\[(.+)\]$/
    if type.length
      toggl.attr = type[1]
    else
      toggl.class = @select_marking

    @toggls.possible = toggl
    @toggls.container = 
      target: @select_container
      bind: [
        [
          'mousedown',
          @select_marking,
          @select_click_handler
        ]
      ]

    super

  select_click_handler: ( e )=>
    return if e.which && e.which != 1

    #@container.data @select_marking, $(e.target).closest(@select_marking)
    @container.css 'background', 'red'

    @turn false

    return
