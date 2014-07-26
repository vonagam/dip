find = -> $ '#main'

$(document).on 'page:restore', ->
  for node in find()
    data = node.data 'react'
    React.renderComponent data.constructor(data.props), node
  return

$(document).on 'page:before-change', ->
  for node in find()
    React.unmountComponentAtNode node
  return
