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

  def valid_placement?(ship, coordinates)
    if ship.length == coordinates.length
      if is_vertical?(coordinates) || is_horizontal?(coordinates)
        true
      else
        false
      end
    else
      false
    end
  end

  def is_vertical?(coordinates)
    range = []
    @cells.map {|cell_key, cell_value| range << cell_key}
    #checks vertically
    coordinates.each_cons(2).all? do | coordinate1, coordinate2 |
      coordinate1[0] == coordinate2[0] && coordinate1[1].to_i == (coordinate2[1].to_i - 1)
    end
  end

  def is_horizontal?(coordinates)
    # A = 65
    # B = 66
    # C = 67
    # D = 68
    range = []
    @cells.map {|cell_key, cell_value| range << cell_key}
    #checks vertically
    coordinates.each_cons(2).all? do | coordinate1, coordinate2 |
      coordinate1[1] == coordinate2[1] && coordinate1[0].ord == (coordinate2[0].ord - 1)
    end
  end

  def place(ship, coordinates)
    if(valid_placement?(ship, coordinates))
      coordinates.each do |coordinate|
        @cells[coordinate].place_ship(ship)
      end
    end
  end
end
