class r.controller.Root
  constructor: ( data )->

    @crsf_meta = $ 'meta[name="csrf-token"]'

    @radio = new state.Radio

    @views = []
    for container in [ 
      'SignOut', 'SignIn', 'SignUp'
      'NewGame', 'Rules', 'Games'
      'Login'
    ]
      view = new r.view[container] this, data
      @views[container] = view
      @radio.add [view]

    @update data


  update: ( data )->
    @user = data.user
    @update_views data

    @crsf_meta.attr 'content', data.crsf
    return


  update_views: ( data )->
    view.update data for name, view of @views
    return


  fetch: ->
    r.page.ajax 'get', '/?format=json', {}, (data)=>
      @update data
      return
    return
