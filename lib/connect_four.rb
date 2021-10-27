# frozen_string_literal: true

require_relative '../lib/display'
require_relative '../lib/player'
require 'matrix'

# class to play a game of Connect Four
class ConnectFour
  attr_accessor :chosen_spots_by_columns, :string_column_locations, :display
  attr_reader :red_circle, :blue_circle

  def initialize
    @display = Display.new
    @red_circle = "\u{1F534}".encode('utf-8')
    @blue_circle = "\u{1F535}".encode('utf-8')
    @chosen_spots_by_columns = Array.new(7, [])
    @string_column_locations = [2, 6, 10, 14, 18, 22, 26]
  end

  def play_game
    establish_players
    @current_player = @player_one
    @display.show_display
    until game_over?(@current_player)
      play_move(@current_player)
      @current_player = @current_player == @player_one ? @player_two : @player_one
    end
    ending_message
  end

  def establish_players
    puts 'Player 1, what is your name?'
    @player_one = Player.new(gets.chomp, @blue_circle)
    puts 'Player 2, what is your name?'
    @player_two = Player.new(gets.chomp, @red_circle)
  end

  def play_move(player, input = nil)
    puts "#{player.name}, which column would you like to drop your piece into?"
    input = gets.chomp until input_valid?(input.to_i)
    place_mark(player.mark, input.to_i)
  end

  def input_valid?(input)
    if [*1..7].include?(input)
      return true unless column_full?(input)

      puts "That column is full. Enter an open column like: (#{@open_columns})"
    else
      puts "That is not a valid input. Enter an open column like: (#{@open_columns})"
    end
    false
  end

  def column_full?(column)
    @chosen_spots_by_columns[column - 1].size == 6
  end

  def place_mark(mark, input)
    x = @string_column_locations[input - 1]
    y = @chosen_spots_by_columns[input - 1].size
    @display.update_display(x, y, mark)
    @chosen_spots_by_columns[input - 1] << mark
  end

  def game_over?(player)
    return true if vertical_win?(player) || horizontal_win?(player) || diagonal_win?(player) || tie?

    false
  end

  def vertical_win?(player)
    @chosen_spots_by_columns.any? do |column|
      next if column.size < 4

      column.each_cons(4).any? do |set|
        @winner = player if set.all?(player.mark)
      end
    end
  end

  def horizontal_win?(player)
    chosen_spots_by_rows = pad_columns.transpose
    chosen_spots_by_rows.any? do |row|
      next if row.size < 4

      row.each_cons(4).any? do |set|
        @winner = player if set.all?(player.mark)
      end
    end
  end

  def pad_columns
    padded_arr = @chosen_spots_by_columns.dup
    padded_arr.each do |column|
      padding = 6 - column.size
      padding.times { column << nil }
    end
  end

  def diagonal_win?(player)
    chosen_spots_by_diagonals = create_diagonals
    chosen_spots_by_diagonals.any? do |diagonal|
      next if diagonal.size < 4

      diagonal.each_cons(4).any? do |set|
        @winner = player if set.all?(player.mark)
      end
    end
  end

  def create_diagonals
    padded_rows = pad_columns.transpose
    diagonals = Array.new(12)
    width = 7
    height = 6
    k = 0
    while k <= width + height - 2
      j = 0
      arr = []
      while j <= k
        i = k - j
        arr << padded_rows[i][j] if i < height && j < width
        j += 1
      end
      diagonals[k] = arr
      k += 1
    end
    diagonals
  end

  def tie?
    return false unless @chosen_spots_by_columns.all? { |column| column.size == 6 }

    @tie = true
    true
  end

  def ending_message

  end
end
