# checkers_qulture_challenge

## Description

Checkers game developed in Ruby for a selective process of a company. 
I have used "ruby2d" for the GUI and installed it following [these](http://www.ruby2d.com/learn/windows/) instructions.

Execute the game through "mingw64.exe" console, opening the main file ("main.rb", inside the "lib" folder) with Ruby.

Grid of this game was based on [this](https://github.com/acouprie/linky) game's grid.

## The game

When the user clicks on the text "Play" the game begins. It can be played with 2 players, using the same mouse. The player 1 always starts and has the white stones. The player 2 has the black ones.
The rules of the game are the same of the traditional checkers game.
When a stone becames pink, it means that it has a mandatory jump for it.
The first player to loose all his stones, looses the game and it ends, showing on the screen who won. To play it again, the user has to close it and open again.

### TODO
Refactor the code doing these things:
- Reduce some functions: separate "drawGrid" (from grid.rb) in two (one for drawing the grid and other to set the variables); separate "createStone" (from grid.rb) in two (one for creating the stone and other for atributions)
- Create a function to check mandatory moves (and by this, you can reduce the size of "movableStone" (from grid.rb))
- Reduce some "ifs"
- In the function "possibleTiles" (from grid.rb), remove some redundancies, change the name of some variables (like "pTiles" and "posTiles") and reduce the "ifs" creating more functions
- Create new functions to reduce the size of "moveStone" (from grid.rb): a function to do atributions, other to check "eaten" conditions and other to check queen conditions
- Extract from "moveStone" (from grid.rb) a function to find the stone that has been eaten
- Extract from "eatStone" (from grid.rb) a function to do atibutions
- Reduce the number of arguments in "findpTilesForQueen", "eatStone" and "moveStone" (all from grid.rb)
- Remove redundant comments
- Remove closing brace comments
