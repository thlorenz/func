puts = require('util').puts
_f = require '../lib/func'

describe 'func', ->
  describe 'when invoked with a function', ->
    w = _f -> "a function"
    it 'returns wrapped function', -> expect(typeof w.fn).toEqual("function")
  describe 'when invoked with an array', ->
    w = _f []
    it 'returns wrapped array', expect(Array.isArray w.xs).toBeTruthy()

describe 'wrapped function', ->
  describe 'that returns 1', ->
    one = _f -> 1
    it 'returns 1 when i invoke fn', -> expect(one.fn()).toEqual 1

  describe 'that adds 1', ->
    add1 = _f (x) -> ++x
    it 'returns 2 when invoked with 1', -> expect(add1.fn 1).toEqual 2
    it 'returns 5 when invoked 4 times with 1', -> expect(add1.times(4).fn 1).toEqual 5

    describe 'composed with a func that multiplies with 3', ->
      mult3 = _f (x) -> 3 * x
      add1mult3 = add1.fwd mult3
      it 'returns 6 when invoked with 1', -> expect(add1mult3.fn 1).toEqual 6
      it 'returns 21 when invoked 2 times with 1', ->
        expect(add1mult3.times(2).fn 1).toEqual 21

      describe 'composed with a func that substacts 4', ->
        sub5 = _f (x) -> x - 4
        ff = add1mult3.fwd sub5
        it 'returns 2 when invoked with 1', -> expect(ff.fn 1).toEqual 2
        it 'returns 5 when invoked 2 times with 1', ->
          expect(ff.times(2).fn 1).toEqual 5

  describe 'that adds two args', ->
    add = _f (x, y) -> x + y
    it 'returns 3 when invoked with 1 and 2', -> expect(add.fn 1, 2).toEqual 3

    describe 'composed with a func that multiplies by 2', ->
      mult2 = _f (x) -> 2 * x
      addMult2 = add.fwd mult2
      it 'returns 6 when invoked with 1 and 2', -> expect(addMult2.fn 1, 2).toEqual 6
      describe 'curried with 2', ->
        add2Mult2 = addMult2.curry 2
        it 'returns 8 when invoked with 2', -> expect(add2Mult2.fn 2).toEqual 8

    describe 'curried with 1', ->
      add1 = add.curry 1
      it 'returns 3 when invoked with 2', -> expect(add1.fn 2).toEqual 3

  describe 'that adds three args', ->
    add = _f (x, y, z) -> x + y + z
    it 'returns 6 when invoked with 1, 2 and 3', -> expect(add.fn 1, 2, 3).toEqual 6

    describe 'curried with 1', ->
      add1 = add.curry 1
      it 'returns 6 when invoked with 2 and 3', -> expect(add1.fn 2, 3).toEqual 6
    describe 'curried with 1 and 2', ->
      add1And2 = add.curry 1, 2
      it 'returns 6 when invoked with 3', -> expect(add1And2.fn 3).toEqual 6

describe 'wrapped arrays', ->
  describe '[]', ->
    a = _f []
    it 'count is 0', expect(a.count()).toEqual 0
    it 'is empty', expect(a.isEmpty()).toBeTruthy()
    it 'is not not empty', expect(a.isNotEmpty()).toBeFalsy()
    it 'xs is underlying array', expect(a.xs).toEqual []
  describe '[1]', ->
    a = _f [1]
    it 'count is 1', expect(a.count()).toEqual 1
    it 'is not empty', expect(a.isEmpty()).toBeFalsy()
    it 'is not empty', expect(a.isNotEmpty()).toBeTruthy()
    it 'xs is underlying array', expect(a.xs).toEqual [1]
  describe '[1, 2, 3, 4, 5, 3, 6]', ->
    xs = _f [1, 2, 3, 4, 5, 3, 6]
    smaller4 = (x) -> x < 4
    it 'take while x < 4 returns [ 1, 2, 3]', ->
      expect(xs.takeWhile(smaller4).xs).toEqual [1, 2, 3 ]
    it 'take while include x < 4 returns [ 1, 2, 3, 4]', ->
      expect(xs.takeWhileInclude(smaller4).xs).toEqual [1, 2, 3, 4 ]
    it 'first x is 3 returns 3', ->
      expect(xs.first (x) -> x is 3).toEqual 3
    it 'first x is 7 returns undefined', ->
      expect(xs.first (x) -> x is 7).toEqual undefined

describe 'utility methods', ->
  describe 'given { x: 1 }', ->
    src = tgt = null
    initCtx = ->
      src = { x: 1 }
      tgt = _f.clone src
    beforeEach -> initCtx()
    initCtx()
    describe 'when i clone it', ->
      it 'x of the clone is 1', -> expect(tgt.x).toEqual 1
      describe 'and change src x to 2', ->
        src.x = 2
        it 'x of the clone is 1', -> expect(tgt.x).toEqual 1
      describe 'and change cloned x to 2', ->
        tgt.x = 2
        it 'x of src is 1', -> expect(src.x).toEqual 1

