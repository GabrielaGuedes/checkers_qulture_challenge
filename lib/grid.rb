require 'ruby2d'

require_relative 'tile'
require_relative 'stone'
require_relative 'player'
require_relative 'game'

class Grid < Square

  def initialize
    @tiles = []
    @grid_size = 8
    @x = 30
    @y = 30
    @tile_size = 70
    @margin = 2
    @color = ['#7FFFD4','#008B8B']
    @players = [Player.new(1),Player.new(2)]
    @hasStone = Array.new(8){Array.new(8)}
    @stoneColor = Array.new(8){Array.new(8)}
    @mandatoryJump = Text.new(
        '',
        x: 705, y: 550,
        size: 20,
        color: '#7FFFD4',
        z: 10
    )
    drawGrid
  end

  def hasStone
    @hasStone
  end

  def vector_tiles
    @tiles
  end

  def getPlayer(nplayer)
    @players[nplayer-1]
  end

  def drawGrid #drawGrid and set some values for the instance variables
    y = @y
    j = 0
    row = 0
    k = 0
    @grid_size.times do
      x = @x
      i = j
      column = 0
      @grid_size.times do
        @tiles << Tile.new(
          x: x,
          y: y,
          size: @tile_size,
          color: @color[i%2],
          row: row,
          column: column,
        )
        @tiles[k].column = column
        @tiles[k].row = row
        @tiles[k].occupied = false
        @hasStone[row][column] = false
        @stoneColor[row][column] = "null"
        x += @tile_size + @margin
        i += 1
        k += 1
        column += 1
      end
      y += @tile_size + @margin
      j += 1
      row += 1
    end
    @tiles
  end

  def createStone(tile, nplayer)
    color = ['white', 'black']
    stone = Stone.new(x: tile.x + tile.size/2, y: tile.y + tile.size/2, radius: 25, color: color[nplayer-1])
    @hasStone[tile.row][tile.column] = true
    @stoneColor[tile.row][tile.column] = color[nplayer-1]
    tile.occupied = true
    tile.stone = stone
    stone.owner = @players[nplayer-1]
    stone.mandatoryMove = false
    @players[nplayer-1].addStone(stone)
    stone.queen = false
    stone.hasEaten = false
    stone
  end


  def putStone
    @tiles.each do |tile|
      if tile.row != 3 && tile.row != 4 #rows 3 and 4 doesn't receive any stone
        if tile.row % 2 == 0 && tile.column % 2 != 0 || tile.row % 2 != 0 && tile.column % 2 == 0 #if the row is even, the tile has stones only in the odd columns (considering that rows and columns start at 0 and end in 7)
          if tile.row < 3 #if so, it's a player2's stone
            createStone(tile, 2)
          else #it's a player1's stone
            createStone(tile, 1)
          end
        end
      end
    end
  end

  def movableStone(player)
    movable = []
    mandatoryJump = false
    @tiles.each do |tile|
      if tile.occupied

        #checks if it has any mandatory movement:
        if tile.stone.owner == player && player.getnPlayer == 1
          if (tile.row-2>=0 && tile.column-2>=0 && @hasStone[tile.row-1][tile.column-1] &&
          !@hasStone[tile.row-2][tile.column-2] && @stoneColor[tile.row-1][tile.column-1] == 'black') ||
          (tile.row-2>=0 && tile.column+2 < 8 && @hasStone[tile.row-1][tile.column+1] &&
          @stoneColor[tile.row-1][tile.column+1] == 'black' && !@hasStone[tile.row-2][tile.column+2])
            movable = [] if !mandatoryJump
            mandatoryJump = true
            tile.stone.color = '#DB7093'
            tile.stone.mandatoryMove = true
            @mandatoryJump.text = "Mandatory Jump"
            movable << tile
          end
        elsif tile.stone.owner == player && player.getnPlayer == 2
          if (tile.row+2<8 && tile.column-2>=0 && @hasStone[tile.row+1][tile.column-1] &&
          !@hasStone[tile.row+2][tile.column-2] && @stoneColor[tile.row+1][tile.column-1] == 'white') ||
          (tile.row+2<8 && tile.column+2<8 && @hasStone[tile.row+1][tile.column+1] &&
          @stoneColor[tile.row+1][tile.column+1] == 'white' && !@hasStone[tile.row+2][tile.column+2])
            movable = [] if !mandatoryJump
            mandatoryJump = true
            tile.stone.color = '#DB7093'
            tile.stone.mandatoryMove = true
            @mandatoryJump.text = "Mandatory Jump"
            movable << tile
          end
        end

        if !mandatoryJump
          if ((player.getnPlayer == 1 && tile.stone.owner == player || tile.stone.queen && tile.stone.owner == player ) &&
          (!@hasStone[tile.row-1][tile.column-1] || !@hasStone[tile.row-1][tile.column+1] )) ||
          ((player.getnPlayer == 1 && tile.stone.owner == player && tile.stone.queen) &&
          ((@hasStone[tile.row-1][tile.column-1] && !@hasStone[tile.row-2][tile.column-2] && @stoneColor[tile.row-1][tile.column-1] == 'black') ||
          (@hasStone[tile.row-1][tile.column+1] && @stoneColor[tile.row-1][tile.column+1] == 'black' && !@hasStone[tile.row-2][tile.column+2]))) ||
          ((player.getnPlayer == 2 && tile.stone.owner == player || tile.stone.queen && tile.stone.owner == player) &&
          (!@hasStone[tile.row+1][tile.column-1] || !@hasStone[tile.row+1][tile.column+1])) ||
          ((player.getnPlayer == 2 && tile.stone.owner == player && tile.stone.queen) &&
          ((@hasStone[tile.row+1][tile.column-1] && !@hasStone[tile.row+2][tile.column-2] && @stoneColor[tile.row+1][tile.column-1] == 'white') ||
          (@hasStone[tile.row+1][tile.column+1] && @stoneColor[tile.row+1][tile.column+1] == 'white' && !@hasStone[tile.row+2][tile.column+2])))
            movable << tile
          end #end if
        end
      end #end if
    end #end do
    movable
  end #end function

  def possibleTiles(tileStone, player) #checks if a tile can be the newTile for the stone
    pTiles = []
    posTiles = []
    if tileStone.class == Tile
      row = tileStone.row
      column = tileStone.column
      if @hasStone[row][column]
        if tileStone.stone.queen
          index1 = [-1,-1,1,1]
          index2 = [-1,1,-1,1]
          i = 0
          (4).times do
            findpTilesForQueen(index1[i], index2[i], row, column, pTiles, player)
            row = tileStone.row
            column = tileStone.column
            i += 1
          end

        elsif !tileStone.stone.queen && player.getnPlayer == 1
          if row-1 >= 0 && column-1 >= 0 && !@hasStone[row-1][column-1] && !tileStone.stone.mandatoryMove
            pTiles << findTile(row-1,column-1)
          elsif row-2 >= 0 && column-2 >= 0 && @hasStone[row-1][column-1] && !@hasStone[row-2][column-2] && @stoneColor[row-1][column-1] == 'black'
            pTiles << findTile(row-2,column-2)
          end
          if row-1 >= 0 && column+1 < 8 && !@hasStone[row-1][column+1] && !tileStone.stone.mandatoryMove
            pTiles << findTile(row-1,column+1)
          elsif row-2 >= 0 && column+2 < 8 && @hasStone[row-1][column+1] && !@hasStone[row-2][column+2] && @stoneColor[row-1][column+1] == 'black'
            pTiles << findTile(row-2,column+2)
          end
        elsif !tileStone.stone.queen && player.getnPlayer == 2
          if row+1 < 8 && column-1 >= 0 && !@hasStone[row+1][column-1] && !tileStone.stone.mandatoryMove
            pTiles << findTile(row+1,column-1)
          elsif row+2 < 8 && column-2 >= 0 && @hasStone[row+1][column-1] && !@hasStone[row+2][column-2] && @stoneColor[row+1][column-1] == 'white'
            pTiles << findTile(row+2,column-2)
          end
          if row+1 < 8 && column+1 < 8 && !@hasStone[row+1][column+1] && !tileStone.stone.mandatoryMove
            pTiles << findTile(row+1,column+1)
          elsif row+2 < 8 && column+2 < 8 && @hasStone[row+1][column+1] && !@hasStone[row+2][column+2] && @stoneColor[row+1][column+1] == 'white'
            pTiles << findTile(row+2,column+2)
          end
        end
      end
    end
    #to avoid bugs and errors:
    pTiles.each do |tile|
      posTiles << tile if tile.class == Tile
    end
    posTiles
  end

  def findpTilesForQueen(index1, index2, row, column, pTiles, player) #called from the function above
    while row+index1 >= 0 && row+index1 < 8 && column+index2 >= 0 && column+index2 < 8
      column += index2
      row += index1
      if !@hasStone[row][column]
        pTiles << findTile(row,column)
      elsif row+index1 >= 0 && row+index1 < 8 && column+index2 >= 0 && column+index2 < 8 && @hasStone[row][column] &&
      !@hasStone[row+index1][column+index2] && ((player.getnPlayer == 1 && @stoneColor[row][column] == 'black') ||
      (player.getnPlayer == 2 && @stoneColor[row][column] == 'white'))
        pTiles << findTile(row+index1,column+index2)
        break
      elsif @hasStone[row][column] && ((player.getnPlayer == 1 && @stoneColor[row][column] == 'white') ||
      (player.getnPlayer == 2 && @stoneColor[row][column] == 'black'))
        break
      end
    end
    pTiles
  end

  def findTile(row, column) #find a tile through its row and column
    @tiles.each do |tile|
      return tile if tile.row == row && tile.column == column
    end
  end

  def moveStone(newTile, oldTile, player) #newTile = the new place for the stone; oldTile = where the stone is now
    color = ['white', 'black']

    player.stones.each do |stone| #find the stone that is on the "oldTile"
      if stone.x == oldTile.x + oldTile.size/2 && stone.y == oldTile.y + oldTile.size/2
        stone.x = newTile.x + newTile.size/2
        stone.y = newTile.y + newTile.size/2

        stone.color = color[player.getnPlayer-1]
        stone.mandatoryMove = false
        @mandatoryJump.text = ""
        newTile.stone = stone
        oldTile.stone = 0
        oldTile.occupied = false
        newTile.occupied = true

        @stoneColor[newTile.row][newTile.column] = color[player.getnPlayer-1]
        @stoneColor[oldTile.row][oldTile.column] = "null"
        @hasStone[newTile.row][newTile.column] = true
        @hasStone[oldTile.row][oldTile.column] = false
      end
    end
    if (newTile.row - oldTile.row) % 2 == 0 && !newTile.stone.queen #if it's even and the stone isn't a queen, the player has eaten a stone
      eatStone(oldTile, newTile, player, newTile.stone.queen)
    elsif newTile.stone.queen #if it's a queen
      eatStone(oldTile, newTile, player, newTile.stone.queen)
    end
    newTile.stone.becomesQueen if (player.getnPlayer == 1 && newTile.row == 0 || player.getnPlayer == 2 && newTile.row == 7) && !newTile.stone.queen
  end

  def eatStone(oldTile, newTile, player, queen)
    if queen
      index1 = 1
      index2 = 1
      index1 = -1 if oldTile.row > newTile.row
      index2 = -1 if oldTile.column > newTile.column

      row = oldTile.row
      column = oldTile.column

      while row != newTile.row && column != newTile.column
        tileEaten = findTile(row,column)
        break if tileEaten.occupied && tileEaten.stone.owner != player
        row += index1
        column += index2
      end

    else #if it isn't a queen
      tileEaten = findTile((oldTile.row+newTile.row)/2, (oldTile.column+newTile.column)/2)
    end

    if tileEaten.occupied
      tileEaten.stone.remove
      if player == @players[0]
        @players[1].removeStone(tileEaten.stone)
      else
        @players[0].removeStone(tileEaten.stone)
      end
      @hasStone[tileEaten.row][tileEaten.column] = false
      newTile.stone.hasEaten = true
      @stoneColor[tileEaten.row][tileEaten.column] = "null"
      tileEaten.stone = 0
      tileEaten.occupied = false
    end
  end

  def setNormalColors
    @players[0].stones.each do |stone|
      stone.color = 'white'
      stone.hasEaten = false
    end
    @players[1].stones.each do |stone|
      stone.color = 'black'
      stone.hasEaten = false
    end
    @mandatoryJump.text = ""
  end

end
