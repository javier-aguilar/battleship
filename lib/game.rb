require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/game'

class Game
  def initialize
    @user_cruiser = nil
    @user_submarine = nil
    @computer_turns = []
  end

  def start
    puts "Welcome to BATTLESHIP \n" +
    "Enter p to play. Enter q to quit."

    user_input = gets.chomp.downcase

    if user_input == "p"
      size = get_board_size

      computer_board = Board.new
      computer_board.generate(size[0], size[1])
      user_board = Board.new
      user_board.generate(size[0], size[1])

      computer_cruiser = Ship.new("Cruiser", 3)
      computer_submarine = Ship.new("Submarine", 2)

      coordinates = randomize_ship_placement(computer_cruiser, computer_board)
      computer_board.place(computer_cruiser, coordinates)

      coordinates2 = randomize_ship_placement(computer_submarine, computer_board)
      computer_board.place(computer_submarine, coordinates2)

      puts "\n=============COMPUTER BOARD=============".red
      puts computer_board.render(true).red

      puts "\n=============PLAYER BOARD==============="
      puts user_board.render(true)
      user_place_ships(user_board)

      turn_counter = 0
      until (computer_cruiser.sunk? && computer_submarine.sunk?) || (@user_cruiser.sunk? && @user_submarine.sunk?)
        puts "\n=============TURN #{turn_counter += 1}============="
        user_fire_shot(computer_board)
        computer_fire_shot(user_board)
      end

      puts "*******************\nYou won!\n*******************" if computer_cruiser.sunk? && computer_submarine.sunk?
      puts "*******************\nI won! ( ⓛ ω ⓛ *)\n*******************".red if @user_cruiser.sunk? && @user_submarine.sunk?
      start

    elsif user_input == "q"
      puts "Quitting game"
    else
      puts "Enter valid input."
    start
    end
  end

  def get_board_size
    user_input = []
    puts "Enter the width of your board."
    print ">"
    user_input << gets.chomp.strip.to_i
    puts "Enter the length of your board."
    print ">"
    user_input << gets.chomp.strip.to_i
  end

  def computer_place_ships(computer_board)
    cruiser = Ship.new("Cruiser", 3)
    coordinates = ["A1", "A2", "A3"]
    computer_board.place(cruiser, coordinates)

    submarine = Ship.new("Submarine", 2)
    coordinates = ["C2", "C3"]
    computer_board.place(submarine, coordinates)
  end

  def user_place_ships(user_board)
    @user_cruiser = Ship.new("Cruiser", 3)

    puts "\nI have laid out my ships on the grid."
    puts "You now need to lay out your two ships."
    puts "The Cruiser is three units long and the Submarine is two units long."
    puts "Enter the squares for the Cruiser. (Ex: A1 A2 A3):"
    print ">"
    coordinates = gets.chomp.upcase.split(" ")

    until user_board.valid_placement?(@user_cruiser, coordinates)
      puts "Those are invalid coordinates. Please try again."
      print "> "
      coordinates = gets.chomp.upcase.split(" ")
    end

    user_board.place(@user_cruiser, coordinates)

    @user_submarine = Ship.new("Submarine", 2)
    puts "Enter the squares for the Submarine. (Ex: B1 B2):"
    print ">"
    coordinates = gets.chomp.upcase.split(" ")

    until user_board.valid_placement?(@user_submarine, coordinates)
      puts "Those are invalid coordinates. Please try again."
      print "> "
      coordinates = gets.chomp.upcase.split(" ")
    end
    user_board.place(@user_submarine, coordinates)
    puts user_board.render(true)
  end


  def user_fire_shot(computer_board)
    puts "Enter the coordinate for your shot:"
    print ">"
    coordinate = gets.chomp.upcase

    until computer_board.valid_coordinate?(coordinate) && computer_board.cells[coordinate].render == "."
      output = ""
      computer_board.cells[coordinate].render != "." ? output = "You already fired on #{coordinate}. Please try again" : output = "Invalid coordinate. Please try again."
      puts output
      print "> "
      coordinate = gets.chomp.upcase
    end
    computer_board.cells[coordinate].fire_upon
    puts "\n=============COMPUTER BOARD=============".red
    puts computer_board.render.red
    results(computer_board, coordinate)
  end

  def computer_fire_shot(user_board)

    coordinate = user_board.cells.keys.sample
    until !@computer_turns.include? coordinate
      coordinate = user_board.cells.keys.sample
    end

    if user_board.cells[coordinate].render == "."
      @computer_turns << coordinate
      user_board.cells[coordinate].fire_upon
      puts "\n=============PLAYER BOARD==============="
      puts "#{user_board.render}\n"
      results(user_board, coordinate, "computer")
    else
      puts "My mistake!"
      computer_fire_shot(user_board)
    end
  end

  def results(board, coordinate, player = "human")
    if board.cells[coordinate].render == "M"
      player == "computer" ? (puts "My shot on #{coordinate} was a miss.") : (puts "Your shot on #{coordinate} was a miss.".red)
    elsif board.cells[coordinate].render == "H"
      player == "computer" ? (puts "My shot on #{coordinate} was a hit.") : (puts "Your shot on #{coordinate} was a hit.".red)
    elsif board.cells[coordinate].render == "X"
      player == "computer" ? (puts "My shot on #{coordinate} sunk your ship.") : (puts "Your shot on #{coordinate} sunk my ship.".red)
    end
  end

  def randomize_ship_placement(ship, board)
    number = rand(1..2)
    number == 1 ? coordinates = vertical_placement(ship, board) : coordinates = horizontal_placement(ship, board)
    coordinates
  end

  def vertical_placement(ship, board)
    switch = false
    while(switch == false)
      coordinates = []
      options = board.cells.select { |key, value| board.cells[key].empty?}
      coordinates << options.keys.sample
      if((coordinates[0][0].ord - 64) <= (board.length - ship.length))
        count = 1
        (ship.length-1).times do
          coordinate = "#{(coordinates[0][0].ord + count).chr}#{(coordinates[0][1])}"
          if board.valid_coordinate?(coordinate) &&  board.cells[coordinate].empty?
            coordinates << coordinate
          else
            break
          end
          count += 1
        end
      end
      switch = board.valid_placement?(ship, coordinates)
    end
    coordinates
  end

  def horizontal_placement(ship, board)
    switch = false
    while(switch == false)
      coordinates = []
      options = board.cells.select { |key, value| board.cells[key].empty?}
      coordinates << options.keys.sample
      if(coordinates[0][1].to_i <= (board.width - ship.length))
        count = 1
        (ship.length-1).times do
          coordinate = "#{coordinates[0][0]}#{(coordinates[0][1].to_i + count)}"
          if board.valid_coordinate?(coordinate) &&  board.cells[coordinate].empty?
            coordinates << coordinate
          else
            break
          end
          count += 1
        end
      end
      switch = board.valid_placement?(ship, coordinates)
    end
    coordinates
  end

end
