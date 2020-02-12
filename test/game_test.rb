require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/game'
require 'colorize'

class GameTest < Minitest::Test

  def setup
    @game = Game.new
    @game.computer_info[:board] = (computer_board = Board.new(4,4))
    @game.user_info[:board] = (user_board = Board.new(4,4))
    @game.computer_info[:board].generate
    @game.user_info[:board].generate

    @game.computer_info[:ships] = {
      submarine: Ship.new('Submarine', 2),
      cruiser: Ship.new('Cruiser', 3)
    }

    @game.user_info[:ships] = {
      submarine: Ship.new('Submarine', 2),
      cruiser: Ship.new('Cruiser', 3)
    }
  end

  def test_is_exists
    game = Game.new
    assert_instance_of Game, game
  end

  def test_summary_if_player_won
    3.times { @game.computer_info[:ships][:cruiser].hit }
    2.times { @game.computer_info[:ships][:submarine].hit }

    expected = "\n*******************\nYou won!\n*******************".green
    assert_equal expected, @game.summary
  end

  def test_summary_if_player_lost
    @game.user_info[:board].place(@game.user_info[:ships][:cruiser], ["A1", "A2", "A3"])
    @game.user_info[:board].place(@game.user_info[:ships][:submarine], ["B1", "B2"])

    3.times { @game.user_info[:ships][:cruiser].hit }
    2.times { @game.user_info[:ships][:submarine].hit }

    expected = "\n*******************\nI won! ( ⓛ ω ⓛ *)\n*******************".red
    assert_equal expected, @game.summary
  end

  def test_is_game_over
    @game.user_info[:board].place(@game.user_info[:ships][:cruiser], ["A1", "A2", "A3"])
    @game.user_info[:board].place(@game.user_info[:ships][:submarine], ["B1", "B2"])
    assert_equal false, @game.is_game_over?

    3.times { @game.user_info[:ships][:cruiser].hit }
    2.times { @game.user_info[:ships][:submarine].hit }
    assert_equal true, @game.is_game_over?
  end

  def test_it_returns_results
    @game.computer_info[:board].place(@game.computer_info[:ships][:cruiser], ["A1", "A2", "A3"])
    @game.computer_info[:board].place(@game.computer_info[:ships][:submarine], ["B1", "B2"])

    @game.user_info[:board].place(@game.user_info[:ships][:cruiser], ["A1", "A2", "A3"])
    @game.user_info[:board].place(@game.user_info[:ships][:submarine], ["B1", "B2"])

    @game.computer_info[:board].cells["C1"].fire_upon
    expected = "Your shot on C1 was a miss.".red
    assert_equal expected, @game.results(@game.computer_info[:board], "C1")

    @game.user_info[:board].cells["C1"].fire_upon
    expected = "My shot on C1 was a miss."
    assert_equal expected, @game.results(@game.user_info[:board], "C1", "computer")

    @game.computer_info[:board].cells["A1"].fire_upon
    expected = "Your shot on A1 was a hit.".red
    assert_equal expected, @game.results(@game.computer_info[:board], "A1")

    @game.user_info[:board].cells["A1"].fire_upon
    expected = "My shot on A1 was a hit."
    assert_equal expected, @game.results(@game.user_info[:board], "A1", "computer")

    @game.computer_info[:board].cells["A2"].fire_upon
    @game.computer_info[:board].cells["A3"].fire_upon
    expected = "Your shot on A3 sunk my ship.".red
    assert_equal expected, @game.results(@game.computer_info[:board], "A3")

    @game.user_info[:board].cells["A2"].fire_upon
    @game.user_info[:board].cells["A3"].fire_upon
    expected = "My shot on A3 sunk your ship."
    assert_equal expected, @game.results(@game.user_info[:board], "A3", "computer")
  end
end
