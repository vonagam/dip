@g = {}

g.controller = {}
g.model = {}
g.view = {}
g.utility = {}


g.initialize = ( game_data )->
  find_views()

  g.map.find('[data-coords]').each ->
    q = $ this
    xy = q.attr('data-coords').split(',')
    q.data 'coords', new Vector({ x: parseInt(xy[0]), y: parseInt(xy[1]) })

  g.game = new g.controller.Game game_data

  utility() for name, utility of g.utility

  return


find_views = ->
  g.page = $ '#games_show'
  g.map = g.page.find '#diplomacy_map'
  g.areas = g.map.children('g').not '#Orders'
  g.orders_visualizations = g.map.children '#Orders'


doc

.on 'page:restore', ->
  game_page = $ '#games_show'
  
  if game_page.length > 0
    find_views()
    g.game = g.page.data 'game'
    g.game.toggle_webscokets true
    g.game.fetch()

  return

.on 'page:receive', ->
  if g.game
    g.game.toggle_webscokets false
    g.page.data 'game', g.game
    g.game = null
  return
