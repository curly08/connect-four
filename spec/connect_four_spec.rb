# frozen_string_literal: true

# rubocop:disable all

require_relative '../lib/connect_four'
require_relative '../lib/player'
require_relative '../lib/display'

describe ConnectFour do
  subject(:game) { described_class.new }

  describe '#play_game' do
    context 'when #game_over? returns true' do
      before do
        allow(game).to receive(:establish_players)
        allow(game).to receive(:game_over?).and_return(true)
      end

      it 'does not #play_move' do
        expect(game).not_to receive(:play_move)
        game.play_game
      end

      it 'shows display' do
        expect(game.display).to receive(:show_display)
        game.play_game
      end
    end

    context 'when #game_over? returns false twice' do
      before do
        allow(game).to receive(:establish_players)
        allow(game).to receive(:game_over?).and_return(false, false, true)
      end
      
      it '#play_move twice' do
        expect(game).to receive(:play_move).twice
        game.play_game
      end
    end
  end

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
        game.instance_variable_set(:@chosen_spots_by_columns, [[],[],[],[],[1,2,3,4,5,6],[],[]])
      end

      it 'returns true' do
        column = 5
        column_check = game.column_full?(column)
        expect(column_check).to eq(true)
      end
    end

    context 'column is not full' do
      before do
        game.instance_variable_set(:@chosen_spots_by_columns, [[],[],[],[],[1,2,3,4,5],[],[]])
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
        chosen_column = game.chosen_spots_by_columns[input.to_i - 1]
        expect { game.place_mark(player.mark, input) }.to change { chosen_column.size }.from(0).to(1)
      end
    end
  end

  # check if game is over
  describe '#game_over?' do
    let(:player) { instance_double(Player, name: 'Matt', mark: 'x') }

    context 'when game has been won vertically' do
      before do
        # game.instance_variable_set(:@chosen_spots_by_columns, [%w[x y x x x y], %w[y y y x y x], %w[x y x x x x y]])
        allow(game).to receive(:vertical_win?).and_return(true)
      end

      it 'returns true' do
        expect(game.game_over?(player)).to be(true)
      end
    end

    context 'when game has been won horizontally' do
      before do
        allow(game).to receive(:horizontal_win?).and_return(true)
      end

      it 'returns true' do
        expect(game.game_over?(player)).to be(true)
      end
    end

    context 'when game has been won diagonally' do
      before do
        allow(game).to receive(:diagonal_win?).and_return(true)
      end

      it 'returns true' do
        expect(game.game_over?(player)).to be(true)
      end
    end

    context 'when game is tied' do
      before do
        allow(game).to receive(:tie?).and_return(true)
      end

      it 'returns true' do
        expect(game.game_over?(player)).to be(true)
      end
    end

    context 'when game has not been won or tied' do
      before do
        allow(game).to receive(:vertical_win?).and_return(false)
        allow(game).to receive(:horizontal_win?).and_return(false)
        allow(game).to receive(:diagonal_win?).and_return(false)
        allow(game).to receive(:tie?).and_return(false)
      end

      it 'returns false' do
        expect(game.game_over?(player)).to be(false)
      end
    end
  end

  describe '#vertical_win?' do
    let(:player) { instance_double(Player, name: 'Matt', mark: 'x') }

    context 'when game has been won vertically' do
      before do
        game.instance_variable_set(:@chosen_spots_by_columns, [%w[x y x x x y], %w[y y y x y x], %w[x y x x x x y]])
      end

      it 'returns true' do
        expect(game.vertical_win?(player)).to be(true)
      end
    end

    context 'when game has not been won vertically' do
      before do
        game.instance_variable_set(:@chosen_spots_by_columns, [%w[x y x x x y], %w[y y y x y x], %w[x y x x x y]])
      end

      it 'returns false' do
        expect(game.vertical_win?(player)).to be(false)
      end 
    end
  end

  describe '#horizontal_win?' do
    let(:player) { instance_double(Player, name: 'Matt', mark: 'x') }

    context 'when game has been won horizontally' do
      before do
        game.instance_variable_set(:@chosen_spots_by_columns, [%w[x x y x y x], %w[y y y y x x], %w[x x x x x x], %w[x y x x y x]])
      end

      it 'returns true' do
        expect(game.horizontal_win?(player)).to be(true)
      end
    end

    context 'when game has not been won horizontally' do
      before do
        game.instance_variable_set(:@chosen_spots_by_columns, [%w[x y x x x y], %w[y x y y y x], %w[x y x x x y], %w[x y x x x y]])
      end

      it 'returns false' do
        expect(game.horizontal_win?(player)).to be(false)
      end
    end
  end

  describe '#diagonal_win?' do
    let(:player) { instance_double(Player, name: 'Matt', mark: 'y') }

    context 'when game has been won diagonally' do
      before do
        game.instance_variable_set(:@chosen_spots_by_columns, [%w[x y x x x y], %w[y x y y y x], %w[x y x x x y], %w[x y x x x y], %w[y x y y y x], %w[y x y y y x], %w[y x y y y x]])
      end

      it 'returns true' do
        expect(game.diagonal_win?(player)).to be(true)
      end
    end

    context 'when game has not been won diagonally' do
      before do
        game.instance_variable_set(:@chosen_spots_by_columns, [%w[x y x x x y], %w[y x y y y x], %w[x y x x x y], %w[x y x x x y], %w[y x y y y x], %w[y x y y y x], %w[y x x y y x]])
      end

      it 'returns false' do
        expect(game.diagonal_win?(player)).to be(false)
      end
    end
  end

  describe '#tie?' do
    context 'when all spaces are filled up' do
      before do
        game.instance_variable_set(:@chosen_spots_by_columns, Array.new(7, %w[x y x x x y]))
      end

      it 'returns true' do
        expect(game.tie?).to be(true)
      end
    end

    context 'when not all spaces are filled up' do
      before do
        game.instance_variable_set(:@chosen_spots_by_columns, Array.new(7, %w[x y x x y]))
      end

      it 'returns false' do
        expect(game.tie?).to be(false)
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
