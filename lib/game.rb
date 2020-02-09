require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/game'

class Game
  def initialize
  end

  def start
    puts "Welcome to BATTLESHIP \n" +
    "Enter p to play. Enter q to quit."

    user_input = gets.chomp.downcase

    if user_input == "p"
      puts "Game loading ..."

      computer_board = Board.new
      length = user_board_length
      width = user_board_width
      computer_board.generate(length, width)
      user_board = Board.new
      # user_board.generate(4, 4)
      computer_place_ships(computer_board)
      user_board.generate(length, width)
      puts "\n=============COMPUTER BOARD============="
      puts computer_board.render

      puts "\n=============PLAYER BOARD============="
      puts user_board.render(true)
      user_place_cruiser(user_board)
      user_place_submarine(user_board)
      # puts user_board.render(true)
      user_fire_shot(computer_board)

      # user_fire_shot(computer_board)
      # puts "\n=============COMPUTER BOARD============="
      # puts computer_board.render

    elsif user_input == "q"
      puts "Quitting game"
    else
      puts "Enter valid input."
    start
    end
  end

  # def user_ships_sunk?
  #   user_cruiser.sunk? && user_submarine.sunk?
  # end
  #
  # def computer_ships_sunk?
  #   computer_cruiser.sunk? && computer_submarine.sunk?
  # end

  def user_board_width
    puts "Enter the width of your board."
    print ">"
    user_input = gets.chomp.strip.to_i
    user_input
  end

  def user_board_length
    puts "Enter the length of your board."
    print ">"
    user_input = gets.chomp.strip.to_i
    user_input
  end

  def computer_place_ships(computer_board)
    cruiser = Ship.new("Cruiser", 3)
    coordinates = ["A1", "A2", "A3"]
    computer_board.place(cruiser, coordinates)

    submarine = Ship.new("Submarine", 2)
    coordinates = ["C2", "C3"]
    computer_board.place(submarine, coordinates)
  end

  def user_place_cruiser(user_board)
    user_cruiser = Ship.new("Cruiser", 3)

    puts "\nI have laid out my ships on the grid."
    puts "You now need to lay out your two ships."
    puts "The Cruiser is three units long and the Submarine is two units long."
    puts "Enter the squares for the Cruiser. (Ex: A1 A2 A3):"
    print ">"
    coordinates = gets.chomp.upcase.split(" ")

    until user_board.valid_placement?(user_cruiser, coordinates)
        puts "Those are invalid coordinates. Please try again."
        print "> "
        coordinates = gets.chomp.upcase.split(" ")
     end

    user_board.place(user_cruiser, coordinates)
  end

  def user_place_submarine(user_board)
    user_submarine = Ship.new("Submarine", 2)
    puts "Enter the squares for the Submarine. (Ex: B1 B2):"
    print ">"
    coordinates = gets.chomp.upcase.split(" ")

    until user_board.valid_placement?(user_submarine, coordinates)
        puts "Those are invalid coordinates. Please try again."
        print "> "
        coordinates = gets.chomp.upcase.split(" ")
    end
    user_board.place(user_submarine, coordinates)
    puts user_board.render(true)
  end

  def user_fire_shot(computer_board)
    puts "Enter the coordinate for your shot:"
    print ">"
    coordinate = gets.chomp.upcase

    until computer_board.valid_coordinate?(coordinate)
      puts "Invalid coordinate. Please try again."
      print "> "
      coordinate = gets.chomp.upcase
    end
    computer_board.cells[coordinate].fire_upon
    puts computer_board.render
  end
end
