# frozen_string_literal: true

class Display
  attr_accessor :rows

  def initialize
    @row_separator = '+---+---+---+---+---+---+---+'
    @column_numbers = '  1   2   3   4   5   6   7  '
    @rows = create_rows
  end

  def create_rows
    Array.new(6).map { |row| row = '|   |   |   |   |   |   |   |' }
  end

  def show_display
    puts @row_separator
    @rows.each { |row| puts row; puts @row_separator }
    puts @column_numbers
  end
end
