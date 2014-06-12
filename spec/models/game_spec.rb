require 'spec_helper'

describe Game do
  before do
    @game = create :game
  end

  it '#initial' do
    expect( @game.status ).to eq 'waiting'
    expect( @game.sides.count ).to eq 1
    expect( @game.sides.first.user ).to eq @game.creator
    expect( @game.states.count ).to eq 1
    expect( @game.states.first._type ).to eq 'State::Move'
    expect( @game.sides.first.power ).to be nil
  end

  describe '#progress!' do
    let(:progress) { -> { @game.progress! } }

    it 'change status' do
      expect( progress ).to change( @game, :status ).from('waiting').to('started')
    end

    it 'not create new state' do
      expect( progress ).not_to change{ @game.states.count }
    end
  end

  it '#randomize_sides' do
    create :side, game: @game, power: nil
    create :side, game: @game, power: ''
    create :side, game: @game, power: ' '

    expect{ @game.send :randomize_sides }
    .to change{ @game.sides.select{ |s| s.power.blank? }.count }.from(4).to(0)
  end

  it '#is_left?' do
    @game.update_attributes time_mode: 'sixty_seconds'

    4.times do |i|
      @game.progress!
      @game.reload
      expect( @game.send :is_left? ).to be (i == 3)
    end
  end

end
