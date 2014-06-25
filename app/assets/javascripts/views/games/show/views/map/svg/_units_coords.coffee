g.part_coords = ( coords, region, part )->
  new Vector coords[ region ].unit[ part ]
g.unit_coords = ( coords, unit )->
  result = g.part_coords coords, unit.area.name, unit.sub_area

  if unit.dislodged
    from = g.part_coords coords, unit.dislodged, 'xc'
    result.add result.dif( from ).norm().scale 14

  result

g.full_coords = ( coords, full_name )->
  parts = full_name.split '_'
  g.part_coords coords, parts[0], parts[1] || 'xc'

g.translate = ( coords )-> "translate(#{ new Vector coords })"
