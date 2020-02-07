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
    puts user_input

    if user_input == "p"
      puts "Game loading ..."
      computer_board = Board.new
      computer_board.generate(4, 4)
      user_board = Board.new
      user_board.generate(4, 4)
      computer_place_ships(computer_board)

      puts "\n=============COMPUTER BOARD============="
      puts computer_board.render

      puts "\n=============PLAYER BOARD============="
      puts user_board.render(true)
      user_place_cruiser(user_board)
      user_place_submarine(user_board)

      user_fire_shot(computer_board)
      puts computer_board.render

    elsif user_input == "q"
      puts "Quitting game"
    else
      puts "Enter valid input."
    start
    end
  end

  # def custom_board_size
  #   puts "My system can handle boards of any size.\n"
  #   puts "Enter Y to create a custom board. Enter N to continue to game play."
  #   print >
  #   user_input = gets.chomp.uppercase
  #   if user_input == "Y"
  #     puts "Enter the length of your board."
  #     print >
  #     length = gets.chomp
  #   else user_input == "N"
  #     user_board.generate(4, 4)
  #     computer_board.generate(4, 4)
  #   end
  # end

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
    puts user_board.render(true)
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
    #this can all be refactored, probably
  end

  def user_fire_shot(computer_board)
    puts "Enter the coordinate for your shot:"
    print ">"
    coordinate = gets.chomp.upcase

    until coordinate.valid_coordinate?(coordinate)
      puts "Those are invalid coordinates. Please try again."
      print "> "
      coordinate = gets.chomp.upcase
    end
    computer_board.fire_upon(coordinate)
    puts computer_board.render
  end
end
