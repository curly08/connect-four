# frozen_string_literal: true

# rubocop:disable all

require_relative '../lib/connect_four'
require_relative '../lib/player'
require_relative '../lib/display'

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
    let(:player) { instance_double(Player, name: 'Matt', mark: 'x') }

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

    context 'when player input is invalid twice' do
      before do
        allow(game).to receive(:puts)
        allow(player).to receive(:name)
      end

      it 'receives #gets 3 times' do
        invalid_input = 'a'
        valid_input = '3'
        expect(game).to receive(:input_valid?).and_return(false, false, false, true)
        expect(game).to receive(:gets).exactly(3).times.and_return(invalid_input, invalid_input, valid_input)
        expect(game).to receive(:place_mark)
        game.play_move(player)
      end
    end
  end

  # verify player input
  describe '#input_valid?' do
    context 'when input is a single column(1..7) with open spot' do
      before do
        allow(game).to receive(:column_full?).and_return(false)
      end

      it 'returns true' do
        input = 4
        verified_input = game.input_valid?(input)
        expect(verified_input).to eq(true)
      end
    end

    context 'when input is not a single column(1..7)' do
      before do
        allow(game).to receive(:puts)
      end

      it 'returns false' do
        input = 'b'
        verified_input = game.input_valid?(input)
        expect(verified_input).to eq(false)
      end

      it 'returns false' do
        input = 8
        verified_input = game.input_valid?(input)
        expect(verified_input).to eq(false)
      end
    end

    context 'when input is a single column(1..7) that is full' do
      before do
        allow(game).to receive(:column_full?).and_return(true)
        allow(game).to receive(:puts)
      end

      it 'returns false' do
        input = '5'
        verified_input = game.input_valid?(input)
        expect(verified_input).to eq(false)
      end
    end
  end

  # check if column is full
  describe '#column_full?' do
    context 'column is full' do
      before do
        game.instance_variable_set(:@chosen_spots, [[],[],[],[],[1,2,3,4,5,6],[],[]])
      end

      it 'returns true' do
        column = 5
        column_check = game.column_full?(column)
        expect(column_check).to eq(true)
      end
    end

    context 'column is not full' do
      before do
        game.instance_variable_set(:@chosen_spots, [[],[],[],[],[1,2,3,4,5],[],[]])
      end

      it 'returns false' do
        column = 5
        column_check = game.column_full?(column)
        expect(column_check).to eq(false)
      end
    end
  end

  # place mark in lowest available space in selected column
  describe '#place_mark' do
    let(:player) { instance_double(Player, name: 'Matt', mark: 'x') }

    context 'when input is 3' do
      it 'sends message to Display' do
        input = 3
        x = 10
        y = 0
        display = game.display
        expect(display).to receive(:update_display).with(x, y, player.mark)
        game.place_mark(player.mark, input)
      end

      it 'adds mark to chosen_spots[2]' do
        input = 3
        chosen_column = game.chosen_spots[input.to_i - 1]
        expect { game.place_mark(player.mark, input) }.to change { chosen_column.size }.from(0).to(1)
      end
    end
  end
end

describe Display do
  subject(:display) { described_class.new }

  describe '#update_display' do
    context 'column 3, row 5 is selected' do
      it 'returns row with inserted mark' do
        x = 10
        y = 4
        mark = 'x'
        expect { display.update_display(x, y, mark) }.to change { display.rows[y] }.from('|   |   |   |   |   |   |   |').to('|   |   | x |   |   |   |   |')
      end
    end
  end
end
