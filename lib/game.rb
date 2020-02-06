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

      puts "=============COMPUTER BOARD============="
      puts computer_board.render
      puts "=============PLAYER BOARD============="
      puts user_board.render(true)
    elsif user_input == "q"
      puts "Quitting game"
    else
      puts "Enter valid input."
      start
    end
  end

  def computer_place_ships(board)
    cruiser = Ship.new("Cruiser", 3)
    coordinates = ["A1", "A2", "A3"]
    board.place(cruiser, coordinates)
  end
end
