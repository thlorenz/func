_f = require '../../func'

# max fields that a piece can move in any given direction
sq = [1..8]


# Experiment with committing and not-committing funcs
setProperty = (ctx, path, value) ->
  propName = null
  nest = ctx
  # Deal with nested properties e.g. human.arm.finger.nail
  pathDepth = path.length - 1
  for index in [0..pathDepth - 1]
    do ->
      propName = path[index]
      nest = nest[propName]
  propName = path[pathDepth]
  nest[propName] = value

getPropertyPathArray = (path) ->
  if path.length is null then path.split '.' else path

class FunctionWrapper
  constructor: (fn, propertyPath) ->
    @fn  = fn
    path = getPropertyPathArray propertyPath
    @fnc = (ctx) => setProperty(ctx, path, @fn ctx)
  fwd: (f) -> _f (params) => f.fn(@fn(params))
_f = (fn, commit) -> new FunctionWrapper(fn, commit)
ctx = { x: {y: 5 } }

left  = _f ((ctx) -> ctx.x.y - 1), 'x.y'

left  = _f ((x) -> x.x - 1), 'x'
right = _f ((x) -> x.x + 1), 'x'
down  = _f ((x) -> x.y - 1), 'y'
up    = _f ((x) -> x.y + 1), 'y'

# End experiment

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

