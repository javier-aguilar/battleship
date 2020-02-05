class Board
  attr_reader :cells

  def initialize
    @cells = {}
  end

  def generate(size)
    #code based on 4 x 4 currently
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
      if (can_place_vertical?(coordinates) || can_place_horizontal?(coordinates)) && is_occupied?(coordinates) == false
        true
      else
        false
      end
    else
      false
    end
  end

  def can_place_horizontal?(coordinates)
    coordinates.each_cons(2).all? do | coordinate1, coordinate2 |
      coordinate1[0] == coordinate2[0] && coordinate1[1].to_i == (coordinate2[1].to_i - 1)
    end
  end

  def can_place_vertical?(coordinates)
    #A = 65, B = 66, C = 67, D = 68
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

  def is_occupied?(coordinates)
    coordinates.one? {|coordinate| @cells[coordinate].empty? }
  end

  def render_board
    col1 = []
    col2 = []
    col3 = []
    col4 = []
    @cells.each do |key, value|
      if key[1].to_i == 1
        col1 << value.render(true)
      elsif key[1].to_i  == 2
        col2 << value.render(true)
      elsif key[1].to_i  == 3
        col3 << value.render(true)
      elsif key[1].to_i  == 4
        col4 << value.render(true)
      end
    end
    puts " 1 2 3 4"
    puts "A #{col1[0]} #{col2[0]} #{col3[0]} #{col4[0]} \n"
    puts "B #{col1[1]} #{col2[1]} #{col3[1]} #{col4[1]} \n"
    puts "C #{col1[2]} #{col2[2]} #{col3[2]} #{col4[2]} \n"
    puts "D #{col1[3]} #{col2[3]} #{col3[3]} #{col4[3]} \n"
  end
end
