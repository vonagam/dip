require 'spec_helper'

describe Message do
  before do
    @user = create(:user)
    @map = Map.find_by( name: 'Standart' )
    @game = @user.created_games.create map: @map
  end

  it 'create' do
    @game.messages.create to: ['Turkey', 'England'], from: 'Germany', text: 'hello1', created_at: Date.today - 30
    @game.messages.create to: ['Italy', 'Germany'], from: 'Austria', text: 'hello2', created_at: Date.today - 20
    @game.messages.create to: ['England'], from: 'France', text: 'hello3', public: true, created_at: Date.today - 10

    info = @game.messages.or( public: true )

    info = info.or( {to: 'Germany'}, {from: 'Germany'} )

    puts info.and( :created_at.gte => (Date.today - 15) ).to_a.size
  end

  # to
  # from
  # public
end
