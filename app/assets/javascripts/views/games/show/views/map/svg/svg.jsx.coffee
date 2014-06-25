###* @jsx React.DOM ###

modulejs.define 'g.v.map.Svg', 
  [ 'g.v.map.svg.Defs', 'g.v.map.svg.Region', 'g.v.map.svg.Order' ]
  ( Defs, Region, Order )->

    React.createClass
      render: ->
        state = @props.state
        regions_coords = @props.coords.regions

        viewBox = "0 0 #{@props.coords.viewBox[0]} #{@props.coords.viewBox[1]}"

        regions = []
        for name, coords of regions_coords
          model = state.areas[ name ]
          regions.push `<Region 
            key={name} 
            name={name} 
            coords={regions_coords} 
            model={model}
            control={this.props.control}
          />`

        orders = []
        for name, power of state.powers
          for unit in power.units
            if order = unit.order
              continue if order.type == 'Hold'
              orders.push `<Order 
                key={unit.area.name+'_'+order.type} 
                order={order} 
                coords={regions_coords} 
              />`

        `<div className='keep_ratio'>
          <svg id='diplomacy_map' viewBox={viewBox}>
            <Defs />
            <g id='regions'>{regions}</g>
            <g id='orders'>{orders}</g>
          </svg>
        </div>`
