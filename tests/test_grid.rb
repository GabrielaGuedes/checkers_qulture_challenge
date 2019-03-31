require_relative '../lib/grid'
require 'test/unit'

class TestGrid < Test::Unit::TestCase

  def testCreateStone
    grid = Grid.new
    assert_equal(grid.createStone(grid.vector_tiles[0],1), grid.getPlayer(1).stones[0])
  end

  def testStonesSize
    grid = Grid.new
    grid.putStone
    assert_equal(12, grid.getPlayer(1).stones_size)
  end

end
