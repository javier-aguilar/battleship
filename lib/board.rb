class Board
  attr_reader :cells, :width, :length

  def initialize
    @cells = {}
    @length = 0
    @width = 0
  end
  def generate(width, length)
    row_count = 1
    col_count = 1
    @length = length
    @width = width
    (@length * @width).times do
      if col_count <= @width && row_count <= @length
        @width.times do
          coordinate = "#{(row_count + 64).chr}#{col_count}"
          @cells[coordinate] = Cell.new(coordinate)
          col_count += 1
        end
        row_count += 1
        col_count = 1
      end
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
      coordinate1_letter = coordinate1[0].ord #Ex: A of A1
      coordinate1_number = coordinate1[1].to_i #Ex: 1 of A1

      coordinate2_letter = coordinate2[0].ord #Ex: A of A2
      coordinate2_number = coordinate2[1].to_i #Ex: 2 of A2

      coordinate1_letter == coordinate2_letter && coordinate1_number == (coordinate2_number - 1)

    end
  end

  def can_place_vertical?(coordinates)
    #A = 65, B = 66, C = 67, D = 68
    coordinates.each_cons(2).all? do | coordinate1, coordinate2 |
      coordinate1_letter = coordinate1[0].ord #Ex: A of A1
      coordinate1_number = coordinate1[1].to_i #Ex: 1 of A1

      coordinate2_letter = coordinate2[0].ord #Ex: A of A2
      coordinate2_number = coordinate2[1].to_i #Ex: 2 of A2

      coordinate1_number == coordinate2_number && coordinate1_letter == (coordinate2_letter - 1)

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
    coordinates.any? {|coordinate| !@cells[coordinate].empty? }
  end

  def render(show_ship = false)
    row_labels = ('A'.. (@length + 64).chr).to_a
    col_labels = (1..@width).to_a
    row_output = []
    output = ""

    output << "  #{col_labels.join (' ')} \n"
    row_labels.each do | row |
      @cells.each do |coordinate, cell|
        if coordinate[0] == row
          row_output << cell.render(show_ship)
        end
      end
      output << "#{row} #{row_output.join(" ")} \n"
      row_output = []
    end
    output
  end
end
