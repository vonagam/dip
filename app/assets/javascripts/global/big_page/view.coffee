class BP.View extends state.Base
  constructor: ( controller, view_name, selector )->
    super()
    controller.views[ view_name ] = this
    @view = controller.bp_page.page.find selector
    @toggls.view_context = @view

  find: ( selector )->
    @view.find selector
