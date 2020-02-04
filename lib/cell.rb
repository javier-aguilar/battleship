class Cell
  attr_reader :coordinate, :ship

  def initialize(coordinate_parameter)
    @coordinate = coordinate_parameter
    @ship = nil
  end

  def empty?
    @ship == nil ? true : false
  end











end
