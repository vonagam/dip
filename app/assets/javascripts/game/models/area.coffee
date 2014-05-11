class klass.Area
  constructor: ( @map, @name, data )->
    @type = data['type']

    view = $('#'+@name)
    views = { 'xc': view }
    view.data 'model', this

    view.children('[id]').each ->
      q = $ this
      sub = q.attr('id').split('_')[1]
      views[sub] = q
      return

    @views = views

    @targeting = {}

    @unit = undefined
