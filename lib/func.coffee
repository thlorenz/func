util = require 'util'

puts = util.puts
inspect = util.inspect

root = this

isFunction = (it) ->
  Object.prototype.toString.call(it) is "[object Function]"

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

_f = (fn) -> new FunctionWrapper fn

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
