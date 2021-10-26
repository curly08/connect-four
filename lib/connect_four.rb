# frozen_string_literal: true

# class to play a game of Connect Four
class ConnectFour
  attr_accessor :chosen_spots, :string_column_locations, :display
  attr_reader :red_circle, :blue_circle

  def initialize
    @display = Display.new
    @red_circle = "\u{1F534}".encode('utf-8')
    @blue_circle = "\u{1F535}".encode('utf-8')
    @chosen_spots = Array.new(7, [])
    @string_column_locations = [2, 6, 10, 14, 18, 22, 26]
  end

  def play_game
    establish_players
    @current_player = @player_one
    until game_over?
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
    @chosen_spots[column - 1].size == 6
  end

  def place_mark(mark, input)
    x = @string_column_locations[input - 1]
    y = @chosen_spots[input - 1].size
    @display.update_display(x, y, mark)
    @chosen_spots[input - 1] << mark
  end

  def game_over?

  end

  def ending_message

  end
end
