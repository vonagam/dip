@r = {}

r.controller = {}
r.view = {}


r.initialize = ( data )->
  find_views()
  r.root = new r.controller.Root data
  return


find_views = ->
  r.page = $ '#application_root'


doc.on 'page:restore', ->
  root_page = $ '#application_root'
  
  if root_page.length > 0
    find_views()

  return
