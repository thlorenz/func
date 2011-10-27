root = this

class FunctionWrapper
  constructor: (fn) -> @fn = fn
  fwd: (f) -> _f (params) => f.fn(@fn(params))
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

_f = (fn) -> new FunctionWrapper fn

root._f = _f

module.exports = _f
