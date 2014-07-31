modulejs.define 'm.Base', ->
  class
    constructor: ( data )->
      return unless data
      for key, value of @$update($merge: data)
        @[key] = value

    $update: ( options )->
      result = React.addons.update this, @$_update options
      result.$after_update? options
      result
    
    $_update: ( all, local = all, path = [] )->
      top = path.length == 0

      if local.$merge
        for key, value of local.$merge
          local[key] = { $set: value }
        delete local.$merge

      for key, value of local
        if /^\$.+/.test(key)
          if @[fun = [key].concat(path).join('_')]
            @[fun] key, value, local, all
          continue

        @$_update all, value, path.concat key

      local
