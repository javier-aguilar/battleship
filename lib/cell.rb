class Cell
  attr_reader :coordinate, :ship

  def initialize(coordinate_parameter)
    @coordinate = coordinate_parameter
    @ship = nil
    @cell_hit = false
  end

  def empty?
    @ship.nil?
  end

  def place_ship(ship)
    @ship = ship
  end

  def fire_upon
    !@ship.nil? ? @ship.hit : false
    @cell_hit = true
  end

  def fired_upon?
    @cell_hit ? true : false
  end

  def render(show_ship = false)
    render_output = ''
    if show_ship == true && !@ship.nil? && fired_upon? == false
      render_output = 'S'
    elsif fired_upon? == false
      render_output = '.'
    elsif fired_upon? == true && @ship.nil?
      render_output = 'M'
    elsif fired_upon? == true && !@ship.nil? && !@ship.sunk?
      render_output = 'H'
    elsif fired_upon? == true && !@ship.nil? && @ship.sunk?
      render_output = 'X'
    end
    render_output
  end
end
