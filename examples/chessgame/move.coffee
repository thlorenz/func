require 'coffee-script'
_f = require '../../lib/func'


# max fields that a piece can move in any given direction
sq = [1..7]

left  = _f (x) -> x.x--; x
right = _f (x) -> x.x++; x
down  = _f (x) -> x.y--; x
up    = _f (x) -> x.y++; x

ne    = up.fwd right
se    = down.fwd right
nw    = up.fwd left
sw    = down.fwd left

allLeft   = sq.map((x) -> left.times x)
allRight  = sq.map((x) -> right.times x)
allDown   = sq.map((x) -> down.times x)
allUp     = sq.map((x) -> up.times x)

allNE     = sq.map((x) -> ne.times x)
allSE     = sq.map((x) -> se.times x)
allNW     = sq.map((x) -> nw.times x)
allSW     = sq.map((x) -> sw.times x)

knightNE  = up.fwd    ne
knightSE  = down.fwd  se
knightNW  = up.fwd    nw
knightSW  = down.fwd  sw

knight = [ knightNE, knightSE, knightNW, knightSW ]

bishop = [].concat allNE, allSE, allNW, allSW

rook = [].concat allLeft, allRight, allDown, allUp

queen = bishop.concat rook

king = [ left, right, up, down, ne, se, nw, sw ]

whitePawn = [ up, up.times(2), ne, nw ]

blackPawn = [ down, down.times(2), se, sw ]

module.exports = {
  left, right, down, up, ne, se, nw, sw,
  allLeft, allRight, allDown, allUp,
  allNE, allSE, allNW, allSW,
  knight, bishop, rook, queen, king, whitePawn, blackPawn
}

