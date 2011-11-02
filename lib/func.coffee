util = require 'util'

puts = util.puts
inspect = util.inspect

root = this

fillValue = (val, depth, currentDepth) ->
  if currentDepth < depth
    clone(val, depth, currentDepth + 1)
  else
    undefined

class FunctionWrapper

  # Creates a wrapped version of the passed function with utility methods added.
  # To get to the wrapped funcion e.g. to execute it use wrapped.fn .
  # All its methods that return new functions wrap them before returning them.
  constructor: (fn) -> @fn = fn

  #  Composes the wrapped function with the passed one.
  #  E.g. add2.fwd mult2 creates a function that adds 2 to an argument and
  #       then multiplies it by 2.
  fwd: (f) -> _f => f.fn(@fn.apply(this, arguments))

  # Creates a function that is executed x times.
  # The result of the previous execution is forwarded to the next execution.
  times: (count) =>
    if count < 1 then throw "Count needs to be 1 or greater for _f.times to work!"
    if count is 1 then return this
    f = null
    for i in [1..count]
      do => f = if not f then this else f.fwd this
    f

  # Curries the wrapped function with the given arguments from left to right.
  curry: ->
    f = this
    curriedArgs = Array::slice.call(arguments)
    return _f ->
      f.fn.apply this, curriedArgs.concat( Array::slice.call(arguments) )

class ArrayWrapper
  constructor: (@xs) ->
  count: -> @xs.length
  isEmpty: -> @xs.length is 0
  isNotEmpty: -> not @isEmpty()

  # Forwards of native Array functions - call it on xs and return wrapped array for collection results
  indexOf:    ->     Array::indexOf.apply @xs, arguments
  lastIndexOf:->     Array::lastIndexOf.apply @xs, arguments
  pop:        ->     Array::pop.apply @xs, arguments
  push:       ->     Array::push.apply @xs, arguments
  reverse:    ->     Array::reverse.apply @xs, arguments
  shift:      ->     Array::shift.apply @xs, arguments
  unshift:    ->     Array::unshift.apply @xs, arguments
  sort:       ->     Array::sort.apply @xs, arguments

  map:        -> _f  Array::map.apply @xs, arguments
  filter:     -> _f  Array::filter.apply @xs, arguments
  concat:     -> _f  Array::concat.apply @xs, arguments
  forEach:    ->     Array::forEach.apply @xs, arguments
  reduce:     ->     Array::reduce.apply @xs, arguments
  reduceRight:->     Array::reduceRight.apply @xs, arguments
  every:      ->     Array::every.apply @xs, arguments
  some:       ->     Array::some.apply @xs, arguments
  join:       ->     Array::join.apply @xs, arguments
  slice:      ->     Array::slice.apply @xs, arguments

  # Returns all array items matching the predicate
  takeWhile: (predicate) ->
    return _f [] if @isEmpty()
    luckyOnes = []
    noScrewUp = true
    index = 0
    while noScrewUp and index < @count()
      do =>
        noScrewUp = predicate @xs[index]
        luckyOnes.push(@xs[index]) if noScrewUp
        index++
    _f luckyOnes

  # Returns first array item matching predicate or undefined if none match
  first: (predicate) ->
    match = undefined
    foundMatch = false
    index = 0
    while index < @count() and (not foundMatch)
      do =>
        foundMatch = predicate @xs[index]
        if foundMatch then match = @xs[index]
        index++
    match

_f = (x) ->
  if isFunction x
    new FunctionWrapper x
  else if Array.isArray x
    new ArrayWrapper x
  else
    throw "only functions and Arrays can be wrapped, not #{typeof x}s"

isFunction = _f.isFunction = (it) ->
  Object.prototype.toString.call(it) is "[object Function]"

###
 *  Copies all properties from source into a target as deep as is configured via depth.
 *  Depth is 1 by default which results in a shallow copy.
 *  It is not cycle proof and therefore needs to be used with care.
 *
 *  @param {Object} src
 *  @param {Number} depth
 *  @return {Object}
 *  @api private
###
_f.clone = clone = (src, depth = 1, currentDepth = 0) ->
  return src                      if src is null or src is `undefined` or isFunction(src)
  return src.slice 0              if Array.isArray src
  return new Date(src.getTime())  if src instanceof Date
  return new RegExp(src) if src   is src instanceof RegExp
  return src                      if typeof(src) isnt 'object'
  target = {}
  target[key] = fillValue(val, depth, currentDepth) for key, val of src
  return target

root._f = _f
module.exports = _f
