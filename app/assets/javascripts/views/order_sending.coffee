@order_sending = ->
  form = $ '#new_order'
  form.on 'ajax:success', ->
    button = form.find 'button'
    if button.hasClass 'yellow'
      button.removeClass 'yellow'
      button.addClass 'green'
