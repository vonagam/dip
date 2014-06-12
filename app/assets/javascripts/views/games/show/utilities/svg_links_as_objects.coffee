g.svgs = {}

filled = false
g.svgs.fill = ->
  return if filled
  filled = true

  defs = g.map.find 'defs > g'

  defs.each ->
    q = $ this
    id = q.attr 'id'
    clone = q.clone().removeAttr('id')
    g.svgs[ id ] = clone

  return

g.svgs.get = (name, klass, coords)->
  g.svgs[name].clone().attr
    class: klass
    transform: "translate(#{coords.x},#{coords.y})"

g.utility.svg_links_as_objects = ->
  centers = g.map.find '.center'

  centers.each ->
    q = $ this

    g.svgs['center'].clone()
    .attr
      class: 'center' 
      transform: q.attr 'transform'
    .insertAfter q
    
    q.remove()

  return
