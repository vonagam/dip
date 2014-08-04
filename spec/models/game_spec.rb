require 'rails_helper'

describe Game do
  different_games :powers_is_random, :is_public, :chat_mode do |variant|
    context variant.to_json do
      before :each do
        @game = create :game, variant
      end

      it '#initial' do
        expect( @game.waiting? ).to be true
        expect( @game.sides.count ).to eq 1
        expect( @game.sides.first.user ).to eq @game.creator
        expect( @game.states.count ).to eq 1
        expect( @game.states.first._type ).to eq 'State::Move'
        expect( @game.sides.first.power ).to be nil
      end

      describe '#start' do
        it 'change status' do
          expect{ @game.start }.to change( @game, :status ).from(:waiting).to(:going)
        end

        it 'not create new state' do
          expect{ @game.start }.not_to change{ @game.states.count }
        end
      end

      describe '#progress' do
        def progress
          @game.start
          @game.progress
        end

        def difference
          @game.start
          start = @game.attributes
          @game.progress
          Hash[start.to_a - @game.attributes.to_a]
        end

        it 'without start - nothing' do
          expect{ @game.progress }.not_to change{ @game.attributes }
        end

        it 'create state' do
          expect{ progress }.to change{ @game.states.count }.by 1
        end

        it 'change current state' do
          expect{ progress }.to change{ @game.state }.from @game.state
        end

        it 'manual - only states' do
          expect( difference.keys ).to eq ['states']
        end

        it 'timed - timer_at change' do
          @game.update_attributes time_mode: '5m'
          expect( difference.keys ).to eq ['states','timer_id']
        end

        it 'multiply times - no problem' do
          expect do
            @game.start
            10.times do
              @game.progress
            end
          end.not_to raise_exception

          expect( @game.states.count ).to eq 11
        end
      end

      describe '#rollback' do
        it 'simple go back' do
          @game.start
          10.times{ @game.progress }
          start = @game.attributes
          @game.progress
          expect( start ).not_to eq @game.attributes
          @game.rollback
          expect( start ).to eq @game.attributes
        end
      end

      it '#progress' do
        @game.start
        state = @game.state
        expect{ @game.progress }.to change{ @game.state }.from(state)
      end

      it '#fill_sides_powers' do
        create :side, game: @game, power: nil

        @game.going!

        expect{ @game.send :fill_sides_powers }
        .to change{ @game.sides.select{ |s| s.power.blank? }.count }.from(2).to(0)
      end

      it '#is_left?' do
        @game.update_attributes time_mode: '5m'
        @game.start

        3.times do |i|
          @game.progress
          expect( @game.is_left? ).to be (i == 2)
        end
      end
    end
  end
end
