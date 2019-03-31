require 'ruby2d'

class Stone < Circle

  attr_accessor :queen
  attr_accessor :owner
  attr_accessor :mandatoryMove
  attr_accessor :hasEaten

  def becomesQueen
    @queen = true
    @radius = 34
  end


end
