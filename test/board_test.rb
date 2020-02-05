require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'

class BoardTest < Minitest::Test

  def test_it_exists
    board = Board.new

    assert_instance_of Board, board
  end


  def test_it_has_cells
    board = Board.new
    cells = {}

    assert_equal cells, board.cells
  end

  def test_if_it_is_valid_coordinate?
    board = Board.new
    board.generate(16)

    assert_equal true, board.valid_coordinate?("A1")
    assert_equal true, board.valid_coordinate?("D4")
    assert_equal false, board.valid_coordinate?("A5")
    assert_equal false, board.valid_coordinate?("E1")
    assert_equal false, board.valid_coordinate?("A22")
  end

  def test_if_it_is_valid_placement_length
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)

    board.generate(16)

    assert_equal false, board.valid_placement?(cruiser, ["A1", "A2"])
    assert_equal false, board.valid_placement?(submarine, ["A2", "A3", "A4"])
  end

  def test_if_it_is_valid_placement_consecutive
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)

    board.generate(16)

    assert_equal false, board.valid_placement?(cruiser, ["A1", "A2", "A4"])
    assert_equal false, board.valid_placement?(submarine, ["A1", "C1"])
    assert_equal false, board.valid_placement?(cruiser, ["A3", "A2", "A1"])
    assert_equal false, board.valid_placement?(submarine, ["C1", "B1"])
  end

  def test_if_it_is_valid_placement_diagonal
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)

    board.generate(16)

    assert_equal false, board.valid_placement?(cruiser, ["A1", "B2", "C3"])
    assert_equal false, board.valid_placement?(submarine, ["C2", "D3"])
  end

  def test_if_valid_placement
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)

    board.generate(16)

    assert_equal true, board.valid_placement?(submarine, ["A1", "A2"])
    assert_equal true, board.valid_placement?(cruiser, ["B1", "C1", "D1"])
  end

  def test_it_can_place
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)

    board.generate(16)
    board.place(cruiser, ["A1", "A2", "A3"])

    cell1 = board.cells["A1"]
    cell2 = board.cells["A2"]
    cell3 = board.cells["A3"]

    cell1.ship
    cell2.ship
    cell3.ship

    assert_equal cell3.ship, cell2.ship
  end

  def test_it_cannot_overlap
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    board.generate(16)

    board.place(cruiser, ["A1", "A2", "A3"])
    submarine = Ship.new("Submarine", 2)

    assert_equal false, board.valid_placement?(submarine, ["A1", "B1"])
  end

  def test_it_can_render
    skip
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    board.generate(16)

    board.place(cruiser, ["A1", "A2", "A3"])
    board.cells["A1"].fire_upon

    submarine = Ship.new("Submarine", 2)
    board.place(submarine, ["C2", "C3"])

    #require "pry"; binding.pry
  end
end
