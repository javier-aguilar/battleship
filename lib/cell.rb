class Cell
  attr_reader :coordinate, :ship

  def initialize(coordinate_parameter)
    @coordinate = coordinate_parameter
    @ship = nil
  end

  def empty?
    @ship == nil ? true : false
  end

  def place_ship(ship)
    @ship = ship
  end

  def fire_upon
    if @ship != nil
      @ship.hit
    end
  end

  def fired_upon?
    if @ship != nil && @ship.length != @ship.health
      true
    else
      false
    end
  end





end
