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
      user_place_ships(user_board)
      puts user_board.render(true)

    elsif user_input == "q"
      puts "Quitting game"
    else
      puts "Enter valid input."
      start
    end
  end

  def computer_place_ships(computer_board)
    cruiser = Ship.new("Cruiser", 3)
    coordinates = ["A1", "A2", "A3"]
    computer_board.place(cruiser, coordinates)
  end

  def user_place_ships(user_board)
    user_cruiser = Ship.new("Cruiser", 3)

    puts "\nI have laid out my ships on the grid."
    puts "You now need to lay out your two ships."
    puts "The Cruiser is three units long and the Submarine is two units long."
    puts "Enter the squares for the Cruiser (3 spaces):"
    print ">"
    coordinates = gets.chomp.upcase.split(" ")

    until user_board.valid_placement?(user_cruiser, coordinates)
        puts "Those are invalid coordinates. Please try again."
        print "> "
        coordinates = gets.chomp.upcase.split(" ")
     end
    user_board.place(user_cruiser, coordinates)
  end
end
