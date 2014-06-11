@g = new BP.Page 'games_show', ->
  @map = @page.find '#diplomacy_map'
  @areas = @map.children('g').not '#Orders'
  @orders_visualizations = @map.children '#Orders'
