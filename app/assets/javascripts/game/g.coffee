@controller = {}
@model = {}
@view = {}

@g = {}

g.initialize = ( game_data )->
  g.page = $ '#games_show'

  g.map = g.page.find '#diplomacy_map'
  
  g.areas = g.map.children('g').not '#Orders'
  g.stats = g.page.find '.stats.j_component table tbody'
  g.orders_visualizations = g.map.children '#Orders'

  g.map.find('[data-coords]').each ->
    q = $ this
    xy = q.attr('data-coords').split(',')
    q.data 'coords', new Vector({ x: parseInt(xy[0]), y: parseInt(xy[1]) })

  g.game = new controller.Game game_data
  return
