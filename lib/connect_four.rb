# frozen_string_literal: true

# class to play a game of Connect Four
class ConnectFour
  def initialize
    @display = <<~HEREDOC


      +-+-+-+-+-+-+-+
      | | | | | | | |
      +-+-+-+-+-+-+-+
      | | | | | | | |
      +-+-+-+-+-+-+-+
      | | | | | | | |
      +-+-+-+-+-+-+-+
      | | | | | | | |
      +-+-+-+-+-+-+-+
      | | | | | | | |
      +-+-+-+-+-+-+-+
      | | | | | | | |
      +-+-+-+-+-+-+-+


    HEREDOC
    @red_circle = "\u{1F534}".encode('utf-8')
    @blue_circle = "\u{1F535}".encode('utf-8')
  end

  def establish_players
    puts 'Player 1, what is your name?'
    @player_one = Player.new(gets.chomp, @blue_circle)
    puts 'Player 2, what is your name?'
    @player_two = Player.new(gets.chomp, @red_circle)
  end
end
