class BP.Controller
  constructor: ( @bp_page, @fetch_url )->
    @views = {}

  update_views: ( data )->
    view.update data for name, view of @views
    return

  fetch: ->
    @bp_page.page.ajax 'get', @fetch_url, {}, ( data )=>
      @update data
      return
    return

  update: ->
    return

  page_stashed: ->
    return

  page_restored: ->
    return

  add_views: ( data, array_of_names )->
    if array_of_names
      for name in array_of_names
        new @bp_page.view[name] this, data
    else
      for name, view of @bp_page.view
        continue if /^(Base|_)/.test name
        new view this, data

    return
