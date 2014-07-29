modulejs.define 'm.Base', ->
  class
    constructor: ( data )->
      $.extend this, @$update $merge: data

    $update: ( options )->
      React.addons.update this, @$_update options
    
    $_update: ( options, path = [] )->
      top = path.length == 0

      if options.$merge
        for key, value of options.$merge
          options[key] = { $set: value }
        delete options.$merge

      for key, value of options
        if /^\$.+/.test(key)
          if @[fun = [key].concat(path).join('_')]
            @[fun] key, value, options
          continue

        @update options, value, path.concat key

      options
