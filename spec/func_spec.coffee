puts = require('util').puts
_f = require '../func'

describe 'func', ->
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

