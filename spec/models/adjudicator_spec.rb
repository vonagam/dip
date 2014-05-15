require 'spec_helper'

describe 'Adjudicator' do
  before do
    @user = create(:user)
    @map = Map.find_by( name: 'Standart' )
    @game = @user.created_games.create map: @map
    @game.progress!
    @user.side_in( @game ).update_attributes power: 'Italy'
    @game.reload
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

    expect( orders['bul']['result'] ).to eq 'SUCCESS'
  end

  it 'retreat' do
    @game.state.update_attributes _type: 'State::Retreat',
      data: '{
      "Embattled":["bud","swe"],
      "Powers":{
        "Russia":{
          "Units":["Arum","Fbot","Abud","Aswe"],
          "Areas":["lvn","rum","mos","sev","war","stp","ukr","fin","bud","swe"]},
        "Italy":{
          "Units":["Avie","Ftri","Abud-gal"],
          "Areas":["gal","vie","tri","tyr","boh"]
        }
      }
    }'

    @game.reload
    
    @game.state.orders.create! data: '{"bud":{"type":"Retreat","to":"ser"}}', side: @user.side_in(@game)

    @game.progress!

    expect( JSON.parse( @game.states.first.orders.first.data )['bud']['result'] ).to eq 'SUCCESS'
  end

  it 'two moves' do
    orders = orders_check(
      '"Fedi","Aliv"',
      '{"liv":{"type":"Move","to":"edi"},"edi":{"type":"Move","to":"nth"}}'
    )

    #puts @game.state.data
  end

  it 'build' do
    @game.state.update_attributes _type: 'State::Supply',
      data: '{
      "Powers":{
        "Italy":{
          "Units":["Arum"],
          "Areas":["lvn","rum","mos","sev","war","stp","ukr","fin","bud","swe"]},
        "Russia":{
          "Units":["Avie","Ftri","Abud"],
          "Areas":["gal","vie","tri","tyr","boh"]
        }
      }
    }'

    @game.reload
    
    @game.state.orders.create! data: '{"stp_nc":{"type":"Build","unit":"fleet"}}', side: @user.side_in(@game)

    @game.progress!

    #puts @game.state.data
  end
end
