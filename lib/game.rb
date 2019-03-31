require 'ruby2d'
require_relative 'grid'

class Game
  attr_accessor :ended
  attr_accessor :started

  def start
    @turn = Text.new(
      '',
      x: 715, y: 150,
      size: 30,
      color: '#7FFFD4',
      z: 10
    )
    @ended = false
    @started = true
  end

  def setFirstTurn(grid)
    grid.getPlayer(1).turn = true
    @turn.text = "Player 1"
    playing(grid)
  end

  def playing(grid)
    tile = 0
    Window.on :mouse do |event|
      case event.button
      when :left
        #player1 turn:
        if grid.getPlayer(1).turn && grid.getPlayer(1).stones_size > 0
          #to check which stones are available to be moved:
          grid.movableStone(grid.getPlayer(1)).each do |tileStone|
            if tileStone.contains? event.x, event.y
              grid.setNormalColors
              tileStone.stone.color = '#FFC0CB'
              tile = tileStone
            end #if
          end #do

          #checking the possibles new tiles for the stone that the player has clicked:
          if grid.possibleTiles(tile, grid.getPlayer(1)).any?
            grid.possibleTiles(tile, grid.getPlayer(1)).each do |pTile|
              if pTile.contains? event.x, event.y
                grid.moveStone(pTile, tile, grid.getPlayer(1)) #pTile = the new place for the stone; tileStone = where the stone is now
                tempStone = grid.movableStone(grid.getPlayer(1))[0].stone #temporary stone only to check the condition below
                if !tempStone.hasEaten || (!tempStone.mandatoryMove && tempStone.hasEaten) #this exists to make it possible to eat 2 stones in one round when necessary
                  #if the program is here, it's because doesn't have any more movement for player1
                  grid.getPlayer(1).turn = false
                  grid.getPlayer(2).turn = true if grid.getPlayer(2).stones_size > 0
                  @turn.text = "Player 2"
                end
                grid.setNormalColors
                grid.getPlayer(1).removeMandatoryStatus
              end #end if
            end #do pTile
          end #if

        #player2 turn:
        elsif grid.getPlayer(2).turn && grid.getPlayer(2).stones_size > 0
          grid.setNormalColors
          #to check which stones are available to be moved:
          grid.movableStone(grid.getPlayer(2)).each do |tileStone|
            if tileStone.contains? event.x, event.y
              grid.setNormalColors
              tileStone.stone.color = '#FFC0CB'
              tile = tileStone
            end #end if
          end #do

          #checking the possibles new tiles for the stone that the player has clicked:
          if grid.possibleTiles(tile, grid.getPlayer(2)).any?
            grid.possibleTiles(tile, grid.getPlayer(2)).each do |pTile|
              if pTile.class == Tile
                if pTile.contains? event.x, event.y
                  grid.moveStone(pTile, tile, grid.getPlayer(2)) #pTile = the new place for the stone; tileStone = where the stone is now
                  tempStone = grid.movableStone(grid.getPlayer(2))[0].stone #temporary stone only to check the condition below
                  if !tempStone.hasEaten || (!tempStone.mandatoryMove && tempStone.hasEaten) #this exists to make it possible to eat 2 stones in one round when necessary
                    #if the program is here, it's because doesn't have any more movement for player2
                    grid.getPlayer(2).turn = false
                    grid.getPlayer(1).turn = true if grid.getPlayer(1).stones_size > 0
                    @turn.text = "Player 1"
                  end
                  grid.setNormalColors
                  grid.getPlayer(2).removeMandatoryStatus
                end #end if
              end
            end #do
          end #if class tile

        #if the game has ended:
        else
          @turn.text = ""
          @ended = true if grid.getPlayer(1).stones_size == 0 || grid.getPlayer(2).stones_size == 0
        end #if turn

      end #end case
    end #do

  end #of function


end
