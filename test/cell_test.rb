require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'

class CellTest < Minitest::Test

  def test_it_exists
    cell = Cell.new("B4")

    assert_instance_of Cell, cell
  end

  def test_it_has_a_coordinate
    cell = Cell.new("B4")

    assert_equal "B4", cell.coordinate
  end

  def test_is_empty
    cell = Cell.new("B4")
    cruiser = Ship.new("Cruiser", 3)
    assert_equal true, cell.empty?

    cell.place_ship(cruiser)

    assert_equal false, cell.empty?
  end

  def test_it_can_place_ship
    cell = Cell.new("B4")
    assert_nil cell.ship

    cruiser = Ship.new("Cruiser", 3)
    cell.place_ship(cruiser)

    assert_equal cruiser, cell.ship
  end

  def test_it_has_been_fired_upon
    cell = Cell.new("B4")
    cruiser = Ship.new("Cruiser", 3)
    cell.place_ship(cruiser)
    assert_equal false, cell.fired_upon?

    cell.fire_upon

    assert_equal true, cell.fired_upon?
  end

  def test_it_can_render
    cell1 = Cell.new("B4")

    assert_equal ".", cell1.render

    cell1.fire_upon
    assert_equal "M", cell1.render

    cell2 = Cell.new("C3")
    cruiser = Ship.new("Cruiser", 3)
    cell2.place_ship(cruiser)
    assert_equal "S", cell2.render(true)

    cell2.fire_upon
    assert_equal "H", cell2.render

    cruiser.hit
    cruiser.hit

    assert_equal "X", cell2.render
  end
end
