@controller = {}
@model = {}
@view = {}

@g = {}


window.g_initialize = ( game_data )->
  find_views()

  g.map.find('[data-coords]').each ->
    q = $ this
    xy = q.attr('data-coords').split(',')
    q.data 'coords', new Vector({ x: parseInt(xy[0]), y: parseInt(xy[1]) })

  g.game = new controller.Game game_data

  return


find_views = ->
  g.page = $ '#games_show'
  g.map = g.page.find '#diplomacy_map'
  g.areas = g.map.children('g').not '#Orders'
  g.orders_visualizations = g.map.children '#Orders'



doc.on 'page:restore', ->
  game_page = $ '#games_show'
  
  if game_page.length > 0
    find_views()
    g.game = g.page.data 'game'
    g.game.toggle_webscokets true
    g.game.fetch()

  return


doc.on 'page:receive', ->
  if g.game
    g.game.toggle_webscokets false
    g.page.data 'game', g.game
    g.game = null
  return
