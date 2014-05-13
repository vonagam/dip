require 'spec_helper'

describe 'Adjudicator' do
  before do
    @user = create(:user)
    @map = Map.find_by( name: 'Standart' )
    @game = @user.created_games.create map: @map
    @game.progress!
    @user.side_in( @game ).power = 'Italy'
  end

  def orders_check( units, orders )
    @game.state.data = '{"Powers":{"Italy":{"Units":['+units+'],"Areas":["rom"]}},"Embattled":[]}'
    @game.state.orders.create! data: orders, side: @user.side_in(@game)

    @game.progress!

    return JSON.parse( @game.states.first.orders.first.data )
  end

  it 'one step convoy' do
    orders = orders_check(
      '"Arom","Ftys"',
      '{"rom":{"type":"Move","to":"tun"},
        "tys":{"type":"Convoy","from":"rom","to":"tun"}}'
    )

    expect( orders['rom']['result'] ).to eq 'SUCCESS'
    expect( orders['tys']['result'] ).to eq 'SUCCESS'
  end

  it 'two step convoy' do
    orders = orders_check(
      '"Arom","Ftys","Fwes"',
      '{"rom":{"type":"Move","to":"naf"},
        "tys":{"type":"Convoy","from":"rom","to":"naf"},
        "wes":{"type":"Convoy","from":"rom","to":"naf"} }'
    )

    expect( orders['rom']['result'] ).to eq 'SUCCESS'
  end

  it 'two ways convoy' do
    orders = orders_check(
      '"Aswe","Fbot","Fbal"',
      '{"swe":{"type":"Move","to":"lvn"},
        "bot":{"type":"Convoy","from":"swe","to":"lvn"},
        "bal":{"type":"Convoy","from":"swe","to":"lvn"} }'
    )

    expect( orders['swe']['result'] ).to eq 'SUCCESS'
    expect( orders['bot']['result'] ).to eq 'SUCCESS'
    expect( orders['bal']['result'] ).to eq 'SUCCESS'
  end

  it 'fleet coast move' do
    orders = orders_check(
      '"Flvn"',
      '{"lvn":{"type":"Move","to":"stp_sc"}}'
    )

    expect( orders['lvn']['result'] ).to eq 'SUCCESS'
  end

  it 'fleet coast move' do
    orders = orders_check(
      '"Fbla"',
      '{"bla":{"type":"Move","to":"bul_ec"}}'
    )

    expect( orders['bla']['result'] ).to eq 'SUCCESS'
  end

  it 'fleet coast move' do
    orders = orders_check(
      '"Fbul_ec"',
      '{"bul":{"type":"Move","to":"bla"}}'
    )

    puts orders
    puts @game.state.data
  end
end
