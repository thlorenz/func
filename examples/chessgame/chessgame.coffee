require 'coffee-script'
_f = require '../../lib/func'
util = require 'util'
puts = util.puts
inspect = util.inspect
dump = ((_f inspect).fwd _f(puts)).fn
move = require './move'
piece = require './piece'
board = require './board'


# ChessGame
# In order to demonstrate how functions that only change one state can be used
# to solve more complex scenarios this example demonstrates how to use this approach
# in order to determine legal chess moves for chess pieces in different scenarios.

#TODO: Once I forward all Array functions, we can remove all these xs forwards

samePosition = (p1, p2) -> p1.x is p2.x and p1.y is p2.y
nonCapturing = ne.takeWhile (x) ->
  position = x.fn bsp.getPosition()
  dump position
  rookPosition = occupiedPositions.xs[1]
  puts "Rook " + inspect rookPosition
  puts rookPosition.x is position.x
  board.isOnBoard(position) and (not occupiedPositions.any((p) -> p is position))
kng = new piece.King('D', 8, 'black')
rok = new piece.Rook('D', 5, 'black')
bsp = new piece.Bishop('B', 3, 'white')
pieces = _f [ bsp, rok ]
occupiedPositions = _f pieces.xs.map((x) -> x.getPosition())

ne = _f bsp.moves[0]
dump(ne.xs.map (x) -> x.fn(bsp.getPosition()))

nonCapturing = ne.takeWhile (x) ->
  position = x.fn bsp.getPosition()
  board.isOnBoard(position) and
    (not occupiedPositions.any((p) -> samePosition p, position))

capturing = ne.first (x) ->
  position = x.fn bsp.getPosition()
  occupiedPositions.any((p) -> samePosition p, position)

nonCapturing.xs[0].fn(bsp.getPosition())

capturing.fn(bsp.getPosition())

