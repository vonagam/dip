@renderReactPage = ( module, data )->
  page = modulejs.require module
  React.renderComponent page(data), $('#main')[0]
  return
