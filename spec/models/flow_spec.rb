require 'spec_helper'

describe 'Flow' do

  def make_orders( power, orders_data = {} )
    orders = {}

    orders_data.each do |k,v|
      orders[k.to_s] = { type: v[0].to_s }.merge!(
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

    @game.orders.create({
      side: @game.side_of( @users[power] ), 
      data: orders
    })
    @game.reload
  end

  def progress!
    @game.progress!
    @game.reload
  end

  def expect_state( type )
    expect( @game.state.type() ).to eq type
  end
  def expect_orderable( count )
    expect( @game.sides.where(orderable: true).count ).to eq count
  end
  def expect_unit( power, unit, bool = true )
    expect( @game.state.data['Powers'][power.to_s]['Units'].include?(unit) ).to be bool
  end

  it '#no_error' do
    #start

    @map = Map.find_by name: 'Standart'

    @users = {}

    @map.info.powers.each do |power|
      @users[power] = create :user
    end

    @game = Game::Manual.create creator: @users['Russia'], map: @map

    @users.each do |power, user|
      if power == 'Russia'
        user.side_in( @game ).update_attributes power: power
      else
        @game.sides.create power: power, user: user
      end
    end

    progress!


    #1
    make_orders 'Russia', war: [:Move, :gal]
    progress!
    expect_unit 'Russia', 'Awar', false
    expect_unit 'Russia', 'Agal'

    #2
    expect_state 'Move'
    expect_orderable 7
    make_orders 'Austria', bud: [:Move, :gal], vie: [:Support, :bud, :gal]
    progress!
    expect( @game.sides.where(orderable: true).first.power ).to eq 'Russia'
    expect_unit 'Russia', 'Agal-bud'

    #3
    expect_state 'Retreat'
    expect_orderable 1
    progress!
    expect( @game.sides.where(orderable: true).first.power ).to eq 'Russia'

    #4
    expect_state 'Supply'
    expect_orderable 1
    make_orders 'Russia', war: [:Build, :army]
    progress!
    expect_unit 'Russia', 'Awar'

    #5
    expect_state 'Move'
    expect_orderable 7
    make_orders 'Turkey', con: [:Move, :bul]
    make_orders 'England', liv: [:Move, :yor], lon: [:Move, :nth] 
    progress!
    expect_unit 'England', 'Ayor'

    #6
    expect_state 'Move'
    make_orders 'England', yor: [:Move, :nor], nth: [:Convoy, :yor, :nor]
    progress!
    expect_unit 'England', 'Anor'

    #7
    expect_state 'Supply'
    expect_orderable 2
    progress!

    #8
    make_orders 'France', mar: [:Move, :pie]
    progress!

    make_orders 'France', pie: [:Move, :ven]
    make_orders 'Austria', tri: [:Support, :pie, :ven]
    progress!

    expect_state 'Retreat'
    make_orders 'Italy', ven: [:Retreat, :tyr]
    progress!
    expect_unit 'Italy', 'Atyr'
  end

  it '#random countries' do
    @map = Map.find_by name: 'Standart'

    @users = {}

    @map.info.powers.each do |power|
      @users[power] = create :user
    end

    @game = @users['Russia'].created_games.create map: @map

    @users.each do |power, user|
      @game.sides.create power: '', user: user unless power == 'Russia'
    end

    progress!

    powers = @game.sides.map{ |x| x.power }

    expect( powers.any?{|x| x.blank?} ).to be false
    expect( powers.uniq.length == powers.length ).to be true
  end
end
