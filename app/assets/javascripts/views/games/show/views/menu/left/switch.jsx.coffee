###* @jsx React.DOM ###

modulejs.define 'g.v.menu.Switch', 
  ['vr.Component', 'vr.classes']
  (Component, classes)->
    Part = React.createClass
      render: ->
        className = classes 'button', current: @props.name == @props.map_or_info
        onMouseDown = @props.setMapOrInfo.bind null, @props.name
        `<div className={className} onMouseDown={onMouseDown} title={this.props.name}>
          <i className={'fa fa-'+this.props.icon}/>
        </div>`

    PARTS_INFOS =
      info: 'cog'
      map: 'globe'

    React.createClass
      render: ->
        parts = {}
        page = @props.page
        
        for name, icon of PARTS_INFOS
          parts[name] = Part 
            name: name
            icon: icon
            map_or_info: page.state.map_or_info
            setMapOrInfo: page.setMapOrInfo

        `<Component className='switch' active={true}>
          {parts}
        </Component>`
