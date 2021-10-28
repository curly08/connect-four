# frozen_string_literal: false

class Display
  attr_accessor :rows

  def initialize
    @row_separator = '+---+---+---+---+---+---+---+'
    @column_numbers = '  1   2   3   4   5   6   7  '
    @rows = Array.new(6) { '|   |   |   |   |   |   |   |' }
  end

  def show_display
    system('clear') || system('cls')
    puts @row_separator
    @rows.each { |row| puts row; puts @row_separator }
    puts @column_numbers
  end

  def update_display(x, y, mark)
    rows[5 - y].slice!(x)
    rows[5 - y].insert(x, mark)
    show_display
  end
end
