require 'spec_helper'

describe Game do
  before do
    @user = create(:user)
    @map = Map.find_by( name: 'Standart' )
    @game = @user.created_games.create map: @map
  end

  it '#create' do
    expect( @game.status ).to eq 'waiting'
    expect( @game.sides.count ).to eq 1
    expect( @game.creator ).to eq @game.sides.first.user
    expect( @game.states.count ).to eq 1
    expect( @game.states.first._type ).to eq 'State::Move'
    expect( @game.sides.first.power ).to be nil
  end

  it '#add_side' do
    expect{ @game.add_side create(:user) }.to change{ @game.sides.count }.by 1
  end

  it '#progress!' do
    expect{ @game.progress! }
    .to change( @game, :status ).from('waiting').to('in_process')
    
    expect( @game.sides.count ).to eq 1
  end

  it '#randomize_sides' do
    @game.add_side create(:user), ' '
    @game.add_side create(:user), ''

    expect{ @game.randomize_sides }
    .to change{ @game.sides.select{ |s| s.power.blank? }.count }.from(3).to(0)
  end

end
