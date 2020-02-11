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
    @game.computer_info[:board].place(@game.computer_info[:ships][:submarine], ["A1", "A2", "A3"])
    @game.computer_info[:board].place(@game.computer_info[:ships][:cruiser], ["B1", "B2"])

    3.times { @game.computer_info[:ships][:cruiser].hit }
    2.times { @game.computer_info[:ships][:submarine].hit }

    expected = "\n*******************\nYou won!\n*******************".green
    assert_equal expected, @game.summary
  end

  def test_summary_if_player_lost
    @game.user_info[:board].place(@game.user_info[:ships][:submarine], ["A1", "A2", "A3"])
    @game.user_info[:board].place(@game.user_info[:ships][:cruiser], ["B1", "B2"])

    3.times { @game.user_info[:ships][:cruiser].hit }
    2.times { @game.user_info[:ships][:submarine].hit }

    expected = "\n*******************\nI won! ( ⓛ ω ⓛ *)\n*******************".red
    assert_equal expected, @game.summary
  end

  def test_game_over
    @game.user_info[:board].place(@game.user_info[:ships][:submarine], ["A1", "A2", "A3"])
    @game.user_info[:board].place(@game.user_info[:ships][:cruiser], ["B1", "B2"])
    assert_equal false, @game.is_game_over?

    3.times { @game.user_info[:ships][:cruiser].hit }
    2.times { @game.user_info[:ships][:submarine].hit }
    assert_equal true, @game.is_game_over?
  end

end
