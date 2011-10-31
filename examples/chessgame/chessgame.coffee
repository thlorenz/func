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

takeUntil = (xs, ctx, predicate) ->
  return [] if xs.length is 0
  getCtx = -> if _f.isFunction(ctx) then ctx() else _f.clone ctx
  luckyOnes = []
  noScrewUp = true
  index = 0
  while noScrewUp and index < xs.length
    do ->
      luckyOnes.push(xs[index])
      noScrewUp = predicate xs[index].fn(getCtx())
      index++
  luckyOnes

first = (xs, predicate) ->


kng = new piece.King('D', 8, 'black')
rok = new piece.Rook('D', 5, 'black')
bsp = new piece.Bishop('B', 3, 'white')
pieces = [ bsp, rok ]
pieces.forEach((x) -> puts x.toString())

ne = bsp.moves[0]
dump(ne.map (x) -> x.fn(bsp.getPosition()))

nonCapturing = takeUntil ne, bsp.getPosition, (x) ->
  board.isOnBoard(x) and pieces.filter((p) -> p isnt x).length is 0

#capturing =

nonCapturing[0].fn(bsp.getPosition())

