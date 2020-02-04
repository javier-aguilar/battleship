class Cell
  attr_reader :coordinate, :ship

  def initialize(coordinate_parameter)
    @coordinate = coordinate_parameter
    @ship = nil
    @cell_hit = false
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
    @cell_hit = true
  end

  def fired_upon?
    @cell_hit ? true : false
  end

  def render
    render_output = ""
    if fired_upon? == false
      render_output = "."
    elsif fired_upon? == true && @ship == nil
      render_output = "M"
    elsif fired_upon? == true && @ship != nil && !@ship.sunk?
      render_output = "H"
    elsif fired_upon? == true && @ship != nil && @ship.sunk?
      render_output = "X"



    end
    render_output
  end





end
