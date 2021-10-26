# frozen_string_literal: true

# class to play a game of Connect Four
class ConnectFour
  def initialize
    # @display = <<~HEREDOC

    #   +-+-+-+-+-+-+-+
    #   | | | | | | | |
    #   +-+-+-+-+-+-+-+
    #   | | | | | | | |
    #   +-+-+-+-+-+-+-+
    #   | | | | | | | |
    #   +-+-+-+-+-+-+-+
    #   | | | | | | | |
    #   +-+-+-+-+-+-+-+
    #   | | | | | | | |
    #   +-+-+-+-+-+-+-+
    #   | | | | | | | |
    #   +-+-+-+-+-+-+-+

    # HEREDOC
    @red_circle = "\u{1F534}".encode('utf-8')
    @blue_circle = "\u{1F535}".encode('utf-8')
  end

  def establish_players
    puts 'Player 1, what is your name?'
    @player_one = Player.new(gets.chomp, @blue_circle)
    puts 'Player 2, what is your name?'
    @player_two = Player.new(gets.chomp, @red_circle)
  end

  def play_move(player, input = nil)
    puts "#{player.name}, which column would you like to drop your piece into?"
    input = gets.chomp until input_valid?(input)
    place_mark(player, input)
  end

  def input_valid?(input)
    if [*1..7].include?(input.to_i)
      return true unless column_full?(input.to_i)

      puts "That column is full. Enter an open column like: (#{@open_columns})"
    else
      puts "That is not a valid input. Enter an open column like: (#{@open_columns})"
    end
    false
  end

  def column_full?(column)
    @chosen_spots[column - 1].size == 6
  end

  def place_mark(player, input)

  end
end
