jQuery.fn.extend
  html_hash: ( hash )->
    for selector, content of hash
      element = this.find '.'+selector

      if typeof content == 'function'
        content element
      else
        element.html content

    return this
