###* @jsx React.DOM ###

g.view.renderButtonComponent = ( 
    className,
    is_active,
    button_options  
  )->
    ->
      Component = vr.Component
      Button = vr.Button

      game = @props.game

      active = is_active game

      button = Button button_options.call this, game if active

      `<Component className={className} active={active}>
        {button}
      </Component>`
