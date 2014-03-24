class g.SelectingState extends klass.State
  constructor: ( hash )->
    super

    @select_selecting = hash.selecting if hash.selecting
    @select_marking = hash.marking if hash.marking
    @select_container = hash.container if hash.container

    toggl = target: @select_selecting

    type = @select_marking.match /^\[(.+)\]$/
    if type.length then toggl.attr = type[1] else toggl.class = @select_marking

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

  toggle: (bool)->
    return true if super

    if bool
      @container.data @select_marking, null

    return

  select_click_handler: ( e )=>
    return if e.which && e.which != 1

    @container.data @select_marking, $(e.target).closest(@select_marking)

    @turn false

    return
