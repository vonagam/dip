modulejs.define 'v.g.s.map.svg.unit_coords',

  part_coords: ( coords, region, part )->
    new Vector coords[ region ].unit[ part ]
  unit_coords: ( coords, unit )->
    result = @part_coords coords, unit.area.name, unit.sub_area

    if unit.dislodged
      from = @part_coords coords, unit.dislodged, 'xc'
      result.add result.dif( from ).norm().scale 14

    result

  full_coords: ( coords, full_name )->
    parts = full_name.split '_'
    @part_coords coords, parts[0], parts[1] || 'xc'

  translate: ( coords )-> "translate(#{ new Vector coords })"
