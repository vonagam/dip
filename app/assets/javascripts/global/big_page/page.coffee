class BP.Page
  constructor: ( @page_id, @find_addtional_views )->
    @controller = {}
    @model = {}
    @view = {}
    @utility = {}

    @initialized = null

    doc.on 'page:restore', =>
      @stash() if @initialized
      @restore() if $('#'+@page_id).length > 0
      return

    doc.on 'page:receive', =>
      @stash() if @initialized
      return


  find_views: ->
    @page = $('#'+@page_id)
    @find_addtional_views.apply this if @find_addtional_views
    return


  initialize: ->
    @find_views()

    @initialized = {}
    for name, controller of @controller
      @initialized[ name ] = new controller arguments

    for name, utility of @utility
      utility()

    return


  restore: ->
    @find_views()

    @initialized = {}
    for name, controller of @controller
      @initialized[ name ] = @page.data @data_name(name)
      @initialized[ name ].page_restored()

    return


  stash: ->
    for name, controller of @initialized
      @page.data @data_name(name), controller
      controller.page_stashed()

    @initialized = null
    return


  data_name: ( controller_name )->
    "#{@page_id}_#{controller_name}"
