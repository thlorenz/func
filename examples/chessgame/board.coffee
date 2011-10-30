require 'coffee-script'
piece = require './piece'
move = require './move'
util = require 'util'
_f = require '../../lib/func'
puts = util.puts
inspect = util.inspect

emptyBoard = [
  " | | | | | | | " #8
  " | | | | | | | " #7
  " | | | | | | | " #6
  " | | | | | | | " #5
  " | | | | | | | " #4
  " | | | | | | | " #3
  " | | | | | | | " #2
  " | | | | | | | " #1
 # a|b|c|d|e|f|g|h"
]
initialBoard = [
  "r|n|b|q|k|b|n|r" #8
  "p|p|p|p|p|p|p|p" #7
  " | | | | | | | " #6
  " | | | | | | | " #5
  " | | | | | | | " #4
  " | | | | | | | " #3
  "P|P|P|P|P|P|P|P" #2
  "R|N|B|Q|K|B|N|R" #1
 # a|b|c|d|e|f|g|h"
]
bishopBoard = [
  " | | | | | | | " #8
  " | | | | | | | " #7
  " | | | | | | | " #6
  " | | | | | | | " #5
  " | | | | |r| | " #4
  " | | | | | | | " #3
  " | | |B| | | | " #2
  " | | | | | | | " #1
 # a|b|c|d|e|f|g|h"
 # 1|2|3|4|5|6|7|8
]

isOnBoard = (x) -> x.x < 9 and x.x > 0 and x.y < 9 and x.y > 0

extractPieces = (stringArray) ->
  rows = stringArray
    .filter((r) -> r[0] isnt '-') # Allow row delimiters -----
    .reverse()

  if rows.length isnt 8 then throw "Chess Board needs to have exactly 8 rows"

  pieces = []
  for key, value of rows
    do (key, value) ->
      rowIndex = parseInt(key) + 1
      ({column: column + 1, char } for char, column in value.split '|' when char isnt ' ')
      .forEach (x) -> pieces.push(piece.toPiece x.char, x.column, rowIndex)
  pieces

class Board
  constructor: (@pieces) ->
  occupied: -> @pieces.map((x) -> x.getPosition())
  toString: -> @pieces
    .map((x) -> "#{x.getShortName()} #{x.getDisplayPosition()}" )

testPieces = extractPieces bishopBoard
board = new Board(testPieces)
bishop = board.pieces[0]

takeUntil = (xs, ctx, predicate) ->
  return [] if xs.length is 0
  currentCtx = _f.clone ctx
  luckyOnes = []
  noScrewUp = true
  index = 0
  while noScrewUp and index < xs.length
    do ->
      luckyOnes.push(xs[index])
      puts (inspect xs[index])
      noScrewUp = predicate(xs[index].fn(currentCtx))
      index++
  luckyOnes

onBoardNE = move.allNE
  .filter((x) -> isOnBoard(x.fn(bishop.getPosition())))

legalNE = takeUntil(onBoardNE, bishop.getPosition(), (x) ->
  board.occupied()
    .filter (o) ->
      puts "occup #{inspect o} pos #{inspect x}"
      o.x == x.x and o.y == x.y
    .length == 0
)

