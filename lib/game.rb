class Game
  
  def initialize
    @user_info =
      {
        ships: {}
      }
    @computer_info =
      {
        ships: {},
        computer_turns: []
      }
  end

  def start
    puts "Welcome to BATTLESHIP \n" + 'Enter p to play. Enter q to quit.'
    print '>'
    user_input = gets.strip.downcase

    if user_input == 'p'
      size = get_board_size

      @computer_info[:board] = (computer_board = Board.new)
      @computer_info[:board].generate(size[0], size[1])
      @user_info[:board] = (user_board = Board.new)
      @user_info[:board].generate(size[0], size[1])

      @computer_info[:ships] = { submarine: Ship.new('Submarine', 2), cruiser: Ship.new('Cruiser', 3) }
      @user_info[:ships] = { submarine: Ship.new('Submarine', 2), cruiser: Ship.new('Cruiser', 3) }

      coordinates = randomize_ship_placement(@computer_info[:ships][:cruiser])
      @computer_info[:board].place(@computer_info[:ships][:cruiser], coordinates)

      coordinates2 = randomize_ship_placement(@computer_info[:ships][:submarine])
      @computer_info[:board].place(@computer_info[:ships][:submarine], coordinates2)

      puts "\n=============COMPUTER BOARD=============".red
      puts @computer_info[:board].render(true).red

      puts "\n=============PLAYER BOARD==============="
      puts @user_info[:board].render(true)
      user_place_ships

      turn_counter = 0
      until is_game_over?
        puts "\n=============TURN #{turn_counter += 1}============="
        user_fire_shot
        computer_fire_shot
      end
      if @computer_info[:ships][:cruiser].sunk? && @computer_info[:ships][:submarine].sunk?
        puts "*******************\nYou won!\n*******************"
      end
      if @user_info[:ships][:cruiser].sunk? && @user_info[:ships][:submarine].sunk?
        puts "*******************\nI won! ( ⓛ ω ⓛ *)\n*******************".red
      end
      @computer_info[:computer_turns] = []
      start
    elsif user_input == 'q'
      puts 'Quitting game. Goodbye!'
    else
      puts 'Enter valid input.'
      start
    end
  end

  def get_board_size
    user_input = []
    puts 'Enter the width of your board.'
    print '>'
    user_input << gets.strip.strip.to_i
    puts 'Enter the length of your board.'
    print '>'
    user_input << gets.strip.strip.to_i
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

    until @computer_info[:board].valid_coordinate?(coordinate) && @computer_info[:board].cells[coordinate].render == '.'
      output = ''
      @computer_info[:board].cells[coordinate].render != '.' ? output = "You already fired on #{coordinate}. Please try again" : output = 'Invalid coordinate. Please try again.'
      puts output
      print '> '
      coordinate = gets.strip.upcase
    end
    @computer_info[:board].cells[coordinate].fire_upon
    puts "\n=============COMPUTER BOARD=============".red
    puts @computer_info[:board].render.red
    results(@computer_info[:board], coordinate)
  end

  def computer_fire_shot
    coordinate = @user_info[:board].cells.keys.sample
    while @computer_info[:computer_turns].include? coordinate
      coordinate = @user_info[:board].cells.keys.sample
    end

    @computer_info[:computer_turns] << coordinate
    @user_info[:board].cells[coordinate].fire_upon
    puts "\n=============PLAYER BOARD==============="
    puts "#{@user_info[:board].render}\n"
    results(@user_info[:board], coordinate, 'computer')
  end

  def results(board, coordinate, player = 'human')
    if board.cells[coordinate].render == 'M'
      player == 'computer' ? (puts "My shot on #{coordinate} was a miss.") : (puts "Your shot on #{coordinate} was a miss.".red)
    elsif board.cells[coordinate].render == 'H'
      player == 'computer' ? (puts "My shot on #{coordinate} was a hit.") : (puts "Your shot on #{coordinate} was a hit.".red)
    elsif board.cells[coordinate].render == 'X'
      player == 'computer' ? (puts "My shot on #{coordinate} sunk your ship.") : (puts "Your shot on #{coordinate} sunk my ship.".red)
    end
  end

  def is_game_over?
    (@computer_info[:ships][:cruiser].sunk? && @computer_info[:ships][:submarine].sunk?) || (@user_info[:ships][:cruiser].sunk? && @user_info[:ships][:submarine].sunk?)
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
          if @computer_info[:board].valid_coordinate?(coordinate) && @computer_info[:board].cells[coordinate].empty?
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
          if @computer_info[:board].valid_coordinate?(coordinate) &&  @computer_info[:board].cells[coordinate].empty?
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
end
