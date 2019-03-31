require 'ruby2d'

require_relative 'stone'

class Player

  attr_accessor :turn
  def initialize(nPlayer)
    @nplayer = nPlayer #1 or 2
    @stones = [] #vector of stones
  end

  def getnPlayer
    @nplayer
  end

  def stones
    @stones
  end

  def removeStone(stone)
    @stones.delete(stone)
  end

  def addStone(stone)
    @stones << stone
  end

  def stones_size #number of stones that the player still has
    @stones.size
  end

  def removeMandatoryStatus
    @stones.each do |stone|
      stone.mandatoryMove = false
    end
  end

end
