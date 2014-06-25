###* @jsx React.DOM ###

g.view.Start = React.createClass
  render: g.view.renderButtonComponent(
      'start'
      ( game )-> game.user_side?.creator && game.data.status == 'waiting'
      ( game )->
        href: Routes.progress_game_path game.data.id, format: 'json'
        className: 'green'
        method: 'post'
        remote: true
        text: 'start'
    )
