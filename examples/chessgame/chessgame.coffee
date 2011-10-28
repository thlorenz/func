require 'coffee-script'
_f = require '../../func'
move = require './move'

# ChessGame
# In order to demonstrate how functions that only change one state can be used
# to solve more complex scenarios this example demonstrates how to use this approach
# in order to determine legal chess moves for chess pieces in different scenarios.

isLegalPosition = (p) -> p.x > 0 and p.x < 9 and p.y > 0 and p.y < 9

rook = new Rook 'B', 2
king = new King 'B', 4
board = { 22: rook, 24: king }

rookMoves = (board, pos) ->
  move.rook
    .map((m) ->
      console.log "Pos", pos
      res = m.fn( pos )
      #console.log "Res", res
      return res
    )
    .filter((p) ->
      isLegalPosition(p) and not board.hasOwnProperty "#{p.x}#{p.y}"
    )
ms = rookMoves board, rook.position()
ms.length

charCodeOffset  = 'A'.charCodeAt(0) - 1
prettyPosition  = (p) -> [ String.fromCharCode(p.x + charCodeOffset), p.y ]

class ChessPiece
  constructor: (x, y) ->
    @x = x.charCodeAt(0) - charCodeOffset
    @y = y
  positionDisplay: -> prettyPosition({ @x, @y })
  position: -> { @x, @y }
  legalMoves: ->
    @moves
      .map((x) => x.fn({ @x, @y }))
      .filter(isLegalPosition)
      .map(prettyPosition)

class Knight extends ChessPiece
  moves: move.knight
class Bishop extends ChessPiece
  moves: move.bishop
class Rook extends ChessPiece
  moves: move.rook

class Queen extends ChessPiece
  moves: move.queen
class King extends ChessPiece
  moves: move.king
  toString: 'King: ' + @position

class Pawn extends ChessPiece
  constructor: (x, y, color) ->
    super(x, y)
    @moves = if color is 'white' then move.whitePawn else move.blackPawn

knight = new Knight('B', 4)
bishop = new Bishop('D', 5)
rook = new Rook('A', 1)
queen = new Queen('D', 1)
king = new King('E', 1)
pawn = new Pawn('E', 2, 'white')
