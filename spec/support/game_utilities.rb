def different_games( *args )
  different_game_variants args
end

VARIANTS = {
  sides_count: [0,1,6],
  progress_count: [false,0,4],
  time_mode: Game::TIME_MODES.keys,
  chat_mode: Game::CHAT_MODES.keys,
  is_public: [true, false],
  powers_is_random: [true, false]
}

def different_game_variants( fields, values = {} )
  return [create(:game, values)] if fields.empty?
  field = fields.shift
  result = []
  VARIANTS[field].each do |variant|
    values[field] = variant
    result += different_game_variants fields, values
  end
  result
end

def order_data( raw )
  powers_orders = {}

  raw.each do |power, orders|
    power_orders = {}

    orders.each do |k,v|
      power_orders[k.to_s] = { type: v[0].to_s }.merge!(
        case v[0]
        when :Move, :Retreat
          { to: v[1].to_s }
        when :Support
          { from: v[1].to_s, to: v.last.to_s }
        when :Convoy
          { from: v[1].to_s, to: v[2].to_s }
        when :Build
          { unit: v[1].to_s }
        end
      )
    end
    
    powers_orders[power] = power_orders
  end

  powers_orders
end

def order_json( raw )
  order_data( raw ).to_json
end

def order_create( raw )
  @game.orders.create side: @side, data: order_data( raw )
  @game.reload
end
