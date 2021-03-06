class Game

  attr_reader :user_info, :computer_info

  def initialize
    @user_info = {ships: {}}
    @computer_info = {ships: {}, computer_turns: []}
  end

  def main_menu
    puts "Welcome to BATTLESHIP\n" + 'Enter p to play. Enter q to quit.'
    print '>'
    user_input = gets.strip.downcase

    if user_input == 'p'
      size = set_board_size

      @computer_info[:board] = (computer_board = Board.new(size[0], size[1]))
      @computer_info[:board].generate
      @user_info[:board] = (user_board = Board.new(size[0], size[1]))
      @user_info[:board].generate

      @computer_info[:ships] = {
        submarine: Ship.new('Submarine', 2),
        cruiser: Ship.new('Cruiser', 3)
      }
      @user_info[:ships] = {
        submarine: Ship.new('Submarine', 2),
        cruiser: Ship.new('Cruiser', 3)
      }

      coordinates = randomize_ship_placement(@computer_info[:ships][:cruiser])
      @computer_info[:board].place(@computer_info[:ships][:cruiser], coordinates)

      coordinates2 = randomize_ship_placement(@computer_info[:ships][:submarine])
      @computer_info[:board].place(@computer_info[:ships][:submarine], coordinates2)

      puts "\n=============COMPUTER BOARD=============".red
      puts @computer_info[:board].render.red

      puts "\n=============PLAYER BOARD==============="
      puts @user_info[:board].render(true)
      user_place_ships

      turn_counter = 0
      until is_game_over?
        puts "\n=============TURN #{turn_counter += 1}=====================".magenta
        user_fire_shot
        computer_fire_shot if !is_game_over?
      end
      puts summary
      main_menu
    elsif user_input == 'q'
      puts 'Quitting game. Goodbye!'
    else
      puts 'Enter valid input.'
      main_menu
    end
  end

  def set_board_size
    user_input = []
    puts 'Enter the width of your board. (Ex: 4)'
    print '>'
    width = gets.chomp.strip.to_i
    until width >= 4
      puts 'Invalid input. Please try again.'
      print '>'
      width = gets.chomp.strip.to_i
    end
    puts 'Enter the length of your board. (Ex: 4)'
    print '>'
    length = gets.chomp.strip.to_i
    until length >= 4 && length <= 26
      puts 'Invalid input. Please try again.'
      print '>'
      length = gets.chomp.strip.to_i
    end
    user_input << width
    user_input << length
    user_input
  end

  def user_place_ships
    puts "\nI have laid out my ships on the grid."
    puts 'You now need to lay out your two ships.'
    puts 'The Cruiser is three units long and the Submarine is two units long.'
    puts 'Enter the squares for the Cruiser. (Ex: A1 A2 A3):'
    print '>'
    coordinates = gets.chomp.upcase.split(' ')

    until @user_info[:board].valid_placement?(@user_info[:ships][:cruiser], coordinates)
      puts 'Those are invalid coordinates. Please try again.'
      print '>'
      coordinates = gets.chomp.upcase.split(' ')
    end
    @user_info[:board].place(@user_info[:ships][:cruiser], coordinates)

    puts 'Enter the squares for the Submarine. (Ex: B1 B2):'
    print '>'
    coordinates = gets.chomp.upcase.split(' ')

    until @user_info[:board].valid_placement?(@user_info[:ships][:submarine], coordinates)
      puts 'Those are invalid coordinates. Please try again.'
      print '> '
      coordinates = gets.chomp.upcase.split(' ')
    end
    @user_info[:board].place(@user_info[:ships][:submarine], coordinates)
    puts @user_info[:board].render(true)
  end

  def user_fire_shot
    puts 'Enter the coordinate for your shot:'
    print '>'
    coordinate = gets.strip.upcase
    until @computer_info[:board].valid_coordinate?(coordinate)
      puts 'Invalid coordinate. Please try again'
      print '>'
      coordinate = gets.strip.upcase
    end

    until @computer_info[:board].cells[coordinate].render == '.'
      output = ''
      if @computer_info[:board].cells[coordinate].fired_upon?
        output = "You already fired on #{coordinate}. Please try again"
      end
      puts output
      print '> '
      coordinate = gets.strip.upcase
    end

    @computer_info[:board].cells[coordinate].fire_upon
    puts display_board("computer")
    puts results(@computer_info[:board], coordinate)
  end

  def computer_fire_shot
    coordinate = @user_info[:board].cells.keys.sample
    while @computer_info[:computer_turns].include? coordinate
      coordinate = @user_info[:board].cells.keys.sample
    end
    @computer_info[:computer_turns] << coordinate
    @user_info[:board].cells[coordinate].fire_upon
    puts display_board
    puts results(@user_info[:board], coordinate, 'computer')
  end

  def display_board(player = "human")
    if player == "computer"
      output = "\n=============COMPUTER BOARD=============\n".red
      output += @computer_info[:board].render.red
    else
      output = "\n=============PLAYER BOARD===============\n"
      output += "#{@user_info[:board].render}\n"
    end
    output
  end

  def results(board, coordinate, player = "human")
    if board.cells[coordinate].render == 'M'
      if player == 'computer'
        output = "My shot on #{coordinate} was a miss."
      else
        output = "Your shot on #{coordinate} was a miss.".red
      end
    elsif board.cells[coordinate].render == 'H'
      if player == 'computer'
        output = "My shot on #{coordinate} was a hit."
      else
        output = "Your shot on #{coordinate} was a hit.".red
        # system(exec "afplay /Users/pippo/turing/1module/battleship/lib/sound.wav")
      end
    elsif board.cells[coordinate].render == 'X'
      if player == 'computer'
        output = "My shot on #{coordinate} sunk your ship."
      else
        output = "Your shot on #{coordinate} sunk my ship.".red
      end
    end
    output
  end

  def is_game_over?
    (@computer_info[:ships][:cruiser].sunk? && @computer_info[:ships][:submarine].sunk?) ||
    (@user_info[:ships][:cruiser].sunk? && @user_info[:ships][:submarine].sunk?)
  end

  def randomize_ship_placement(ship)
    number = rand(1..2)
    number == 1 ? coordinates = vertical_placement(ship) : coordinates = horizontal_placement(ship)
    coordinates
  end

  def vertical_placement(ship)
    switch = false
    while switch == false
      coordinates = []
      options = @computer_info[:board].cells.select { |key, _value| @computer_info[:board].cells[key].empty? }
      coordinates << options.keys.sample
      if (coordinates[0][0].ord - 64) <= (@computer_info[:board].length - ship.length)
        count = 1
        (ship.length - 1).times do
          coordinate = "#{(coordinates[0][0].ord + count).chr}#{(coordinates[0][1])}"
          if @computer_info[:board].valid_coordinate?(coordinate) &&
            @computer_info[:board].cells[coordinate].empty?
              coordinates << coordinate
          else
            break
          end
          count += 1
        end
      end
      switch = @computer_info[:board].valid_placement?(ship, coordinates)
    end
    coordinates
  end

  def horizontal_placement(ship)
    switch = false
    while switch == false
      coordinates = []
      options = @computer_info[:board].cells.select { |key, _value| @computer_info[:board].cells[key].empty? }
      coordinates << options.keys.sample
      if coordinates[0][1].to_i <= (@computer_info[:board].width - ship.length)
        count = 1
        (ship.length - 1).times do
          coordinate = "#{coordinates[0][0]}#{(coordinates[0][1].to_i + count)}"
          if @computer_info[:board].valid_coordinate?(coordinate) &&
            @computer_info[:board].cells[coordinate].empty?
              coordinates << coordinate
          else
            break
          end
          count += 1
        end
      end
      switch = @computer_info[:board].valid_placement?(ship, coordinates)
    end
    coordinates
  end

  def summary
    if @computer_info[:ships][:cruiser].sunk? && @computer_info[:ships][:submarine].sunk?
      output = "\n*******************\nYou won!\n*******************".green
    else
      output = "\n*******************\nI won! ( ⓛ ω ⓛ *)\n*******************".red
    end
    @computer_info[:computer_turns] = []
    output
  end
end
