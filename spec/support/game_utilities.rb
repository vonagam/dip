def progress!
  @game.progress!
  @game.reload
end

def order_data( raw )
  data = {}

  raw.each do |k,v|
    data[k.to_s] = { type: v[0].to_s }.merge!(
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

  data
end

def order_json( raw )
  order_data( raw ).to_json
end

def order_create( raw )
  @game.orders.create side: @side, data: order_data( raw )
  @game.reload
end
