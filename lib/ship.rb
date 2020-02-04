class Ship

  attr_reader :name, :length, :health

  def initialize(name_parameter, length_parameter)
    @name = name_parameter
    @length = length_parameter
    @health = length_parameter
  end

  def sunk?
    @health == 0 ? true : false
  end

  def hit
    @health > 0 ? @health -= 1 : @health
  end
end
