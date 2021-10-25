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
end
