###* @jsx React.DOM ###

modulejs.define 'v.g.s.menu.buttonComponent',
  [ 'vr.Component', 'vr.Button', 'vr.classes' ]
  ( Component, Button, classes )->
    
    ( className, is_active, button_options )->
      ->
        game = @props.game
        active = is_active game
        button = Button button_options.call this, game if active

        `<Component className={className} active={active}>
          {button}
        </Component>`
