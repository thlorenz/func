require 'coffee-script'
_f = require '../../lib/func'
move = require './move'

charCodeOffset  = 'A'.charCodeAt(0) - 1
xToChar = (x) -> String.fromCharCode(x + charCodeOffset)
charToX = (x) -> x.charCodeAt(0) - charCodeOffset
displayPosition  = (p) -> "#{xToChar(p.x)}#{p.y}"

toPiece = (id, x, y) ->
  xChar = xToChar x
  color = if id.toUpperCase() is id then 'white' else 'black'
  switch id.toUpperCase()
    when 'R' then new Rook(xChar, y, color)
    when 'N' then new Knight(xChar, y, color)
    when 'B' then new Bishop(xChar, y, color)
    when 'Q' then new Queen(xChar, y, color)
    when 'K' then new King(xChar, y, color)
    when 'P' then new Pawn(xChar, y, color)
    else throw "unkown chess piece code #{id}"

class ChessPiece
  constructor: (x, y, color) ->
    @x = x.charCodeAt(0) - charCodeOffset
    @y = y
    @x_coord = @x - 1
    @y_coord = @y - 1
    @color = color
  getDisplayPosition: -> displayPosition({ @x, @y })
  getPosition: -> { @x, @y }
  getShortName: -> if @color is 'white' then @code else @code.toLowerCase()
  legalMoves: ->
    @moves
      .map((x) => x.fn({ @x, @y }))
      .filter(isLegalPosition)
      .map(displayPosition)
  toString: -> "#{@color} #{@name} #{@positionDisplay()}"


class Knight extends ChessPiece
  code: 'N'
  name: 'Knight'
  moves: move.knight

class Bishop extends ChessPiece
  code: 'B'
  name: 'Bishop'
  moves: move.bishop

class Rook extends ChessPiece
  code: 'R'
  name: 'Rook'
  moves: move.rook

class Queen extends ChessPiece
  code: 'Q'
  name: 'Queen'
  moves: move.queen

class King extends ChessPiece
  code: 'K'
  name: 'King'
  moves: move.king

class Pawn extends ChessPiece
  constructor: (x, y, color) ->
    super(x, y, color)
    @moves = if color is 'white' then move.whitePawn else move.blackPawn
  code: 'P'
  name: 'Pawn'

module.exports = { Knight, Bishop, Rook, Queen, King, Pawn, charToX, xToChar, toPiece }
