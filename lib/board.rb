class Board
  attr_reader :cells

  def initialize
    @cells = {}
  end

  def generate(size)
    #letters = ('a'..'z').to_a
    count = 1
    size.times do
      if count <= 4
        key = "A#{count}"
        @cells[key] = Cell.new(key)
      elsif count <= 8
        key = "B#{count-4}"
        @cells[key] = Cell.new(key)
      elsif count <= 12
        key = "C#{count-8}"
        @cells[key] = Cell.new(key)
      elsif count <= 16
        key = "D#{count-12}"
        @cells[key] = Cell.new(key)
      end
      count += 1
    end
  end

  def valid_coordinate?(coordinate)
    @cells.key? coordinate
  end
end
