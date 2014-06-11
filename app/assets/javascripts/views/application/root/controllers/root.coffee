class r.controller.Root extends BP.Controller
  constructor: ( page_arguments )->
    super r, '/?format=json'

    data = page_arguments[0]

    @crsf_meta = $ 'meta[name="csrf-token"]'

    @radio = new state.Radio

    @add_views data

    for name, view of @views
      @radio.add [view]

    @update data


  update: ( data )->
    @user = data.user
    @update_views data

    @crsf_meta.attr 'content', data.crsf
    return
