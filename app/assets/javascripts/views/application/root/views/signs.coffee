class Sign extends r.view.Base
  constructor: ( root, in_up_out )->
    super root, "sign_#{in_up_out}"
    @view.on 'ajax:success', =>
      @root.fetch()
      return false


class r.view.SignIn extends Sign
  constructor: ( root )->
    super root, 'in'
  is_enable: ->
    @root.user == undefined

class r.view.SignUp extends Sign
  constructor: ( root )->
    super root, 'up'
  is_enable: ->
    @root.user == undefined

class r.view.SignOut extends Sign
  constructor: ( root )->
    super root, 'out'
  is_enable: ->
    @root.user != undefined
