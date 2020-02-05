class Cell
  attr_reader :coordinate, :ship

  def initialize(coordinate_parameter)
    @coordinate = coordinate_parameter
    @ship = nil
    @cell_hit = false
  end

  def empty?
    @ship == nil
  end

  def place_ship(ship)
    @ship = ship
  end

  def fire_upon
    @ship != nil ? @ship.hit : false
    @cell_hit = true
  end

  def fired_upon?
    @cell_hit ? true : false
  end

  def render(show = false)
    render_output = ""
    if fired_upon?
      if @ship != nil
        if @ship.sunk?
          render_output = "X"
        else
          render_output = "H"
        end
      else
        render_output = "M"
      end
    else
      if show == true && @ship != nil
        render_output = "S"
      else
        render_output = "."
      end
    end
  end
end
