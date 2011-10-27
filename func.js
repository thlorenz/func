(function() {
  var FunctionWrapper, root, _f;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  root = this;
  FunctionWrapper = (function() {
    function FunctionWrapper(fn) {
      this.times = __bind(this.times, this);      this.fn = fn;
    }
    FunctionWrapper.prototype.fwd = function(f) {
      return _f(__bind(function(params) {
        return f.fn(this.fn(params));
      }, this));
    };
    FunctionWrapper.prototype.times = function(count) {
      var f, i, _fn;
      f = null;
      _fn = __bind(function() {
        return f = !f ? this : f.fwd(this);
      }, this);
      for (i = 1; 1 <= count ? i <= count : i >= count; 1 <= count ? i++ : i--) {
        _fn();
      }
      return f;
    };
    FunctionWrapper.prototype.curry = function() {
      var curriedArgs, f;
      f = this;
      curriedArgs = Array.prototype.slice.call(arguments);
      return _f(function() {
        return f.fn.apply(this, curriedArgs.concat(Array.prototype.slice.call(arguments)));
      });
    };
    return FunctionWrapper;
  })();
  _f = function(fn) {
    return new FunctionWrapper(fn);
  };
  root._f = _f;
  module.exports = _f;
}).call(this);
