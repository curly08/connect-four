# frozen_string_literal: true

# rubocop:disable all

require_relative '../lib/connect_four'
require_relative '../lib/player'

describe ConnectFour do
  subject(:game) { described_class.new }

  # establish players
  describe '#establish_players' do
    context 'two players are created' do
      before do
        allow(game).to receive(:puts)
        allow(game).to receive(:gets).and_return('matt', 'gary')
      end

      it 'creates two Player objects' do
        expect(Player).to receive(:new).twice
        game.establish_players
      end
    end
  end

  # player plays move
  describe '#play_move' do
    let(:player) { instance_double(Player, 'Matt') }

    context 'when player picks valid column(1..7) to place mark' do
      before do
        allow(game).to receive(:puts)
        allow(player).to receive(:name)
      end

      it 'receives input and verifies its validity' do
        input = '1'
        expect(game).to receive(:input_valid?).and_return(false, true)
        expect(game).to receive(:gets).and_return(input)
        expect(game).to receive(:place_mark)
        game.play_move(player)
      end
    end
  end
end
