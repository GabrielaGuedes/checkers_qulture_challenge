require 'ruby2d'
require_relative 'grid'
require_relative 'tile'
require_relative 'game'


set title: "Damas", background: 'navy', width: 900, height: 630

line = Line.new(
  x1: 650, y1: 30,
  x2: 650, y2: 605,
  width: 5,
  color: 'lime',
  z: 20
)

play = Text.new(
  'Play',
  x: 740, y: 150,
  size: 30,
  color: '#7FFFD4',
  z: 10
)

grid = Grid.new
started = false
game = Game.new
firstTime = true

on :mouse do |event|
  if play.contains? Window.mouse_x, Window.mouse_y #to highlight the text
    play.color =  '#FF0000'
  else
    play.color = '#7FFFD4'
  end

  case event.button
  when :left
    if play.contains? event.x, event.y #when the user clicks on it, the game begins
      play.text = ""
      game.start
      grid.putStone
    end #end if
  end #end case
end #mouse event


update do
  if game.started && firstTime
    game.setFirstTurn(grid) #this function will call the game main function ("playing", from "game.rb")
    firstTime = false
  end
  if game.ended
    clear
    winner = Text.new(
      '',
      x: 370, y: 300,
      size: 30,
      color: '#7FFFD4',
      z: 10
    )
    if grid.getPlayer(2).stones_size == 0
      winner.text = "Player 1 won"
    else
      winner.text = "Player 2 won"
    end
  end
  started = false
end





show
