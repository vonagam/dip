class r.view.Login extends r.view.Base
  constructor: ( root )->
    super root, 'login'

  is_enable: ->
    @root.user != undefined

  enable: ( bool )->
    super
    
    @view.html if @enabled then @root.user.login else ''

    return
