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
clone = (src, depth = 1, currentDepth = 0) ->
  return src                      if src is null or src is `undefined` or isFunction(src)
  return src.slice 0              if Array.isArray src
  return new Date(src.getTime())  if src instanceof Date
  return new RegExp(src) if src   is src instanceof RegExp
  return src                      if typeof(src) isnt 'object'
  target = {}
  target[key] = fillValue(val, depth, currentDepth) for key, val of src
  return target

class FunctionWrapper
  constructor: (fn) -> @fn = fn
  fwd: (f) -> _f => f.fn(@fn(arguments))
  times: (count) =>
    f = null
    for i in [1..count]
      do => f = if not f then this else f.fwd this
    f
  curry: ->
    f = this
    curriedArgs = Array::slice.call(arguments)
    return _f ->
      f.fn.apply this, curriedArgs.concat( Array::slice.call(arguments) )
  # Clone method (see above)
  clone: clone

_f = (fn) -> new FunctionWrapper fn

root._f = _f
module.exports = _f
