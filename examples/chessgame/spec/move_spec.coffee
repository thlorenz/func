_f = require '../../../lib/func'
move = require '../move'


describe 'given position: x: 2, y: 2', ->
  pos = null
  initCtx = -> pos = { x: 2, y: 2}
  beforeEach -> initCtx()

  describe 'simple moves', ->
    it 'up    moves to x: 2, y: 3', -> expect(move.up.fn    pos).toEqual { x: 2, y: 3 }
    it 'down  moves to x: 2, y: 1', -> expect(move.down.fn  pos).toEqual { x: 2, y: 1 }
    it 'left  moves to x: 1, y: 2', -> expect(move.left.fn  pos).toEqual { x: 1, y: 2 }
    it 'right moves to x: 3, y: 2', -> expect(move.right.fn pos).toEqual { x: 3, y: 2 }

    it 'ne moves to x: 3, y: 3', -> expect(move.ne.fn pos).toEqual { x: 3, y: 3 }
    it 'se moves to x: 3, y: 1', -> expect(move.se.fn pos).toEqual { x: 3, y: 1 }
    it 'nw moves to x: 1, y: 3', -> expect(move.nw.fn pos).toEqual { x: 1, y: 3 }
    it 'sw moves to x: 1, y: 1', -> expect(move.sw.fn pos).toEqual { x: 1, y: 1 }

  describe 'multi moves', ->
    it 'all up moves range from x: 2, y: 3 to x: 2, y: 9 and are ordered', ->
      moves = move.allUp
      expect(moves.length).toEqual 7
      expect(moves.map (x) -> x.fn(_f.clone pos)).toEqual [
          { x: 2, y: 3 },
          { x: 2, y: 4 },
          { x: 2, y: 5 },
          { x: 2, y: 6 },
          { x: 2, y: 7 },
          { x: 2, y: 8 },
          { x: 2, y: 9 }]
    it 'all down moves range from x: 2, y: 1 to x: 2, y: -5 and are ordered', ->
      moves = move.allDown
      expect(moves.length).toEqual 7
      expect(moves.map (x) -> x.fn(_f.clone pos)).toEqual [
          { x: 2, y:  1 },
          { x: 2, y:  0 },
          { x: 2, y: -1 },
          { x: 2, y: -2 },
          { x: 2, y: -3 },
          { x: 2, y: -4 },
          { x: 2, y: -5 }]
    it 'all left moves range from x: 1, y: 2 to x: -5, y: 2 and are ordered', ->
      moves = move.allLeft
      expect(moves.length).toEqual 7
      expect(moves.map (x) -> x.fn(_f.clone pos)).toEqual [
          { x:  1, y: 2 },
          { x:  0, y: 2 },
          { x: -1, y: 2 },
          { x: -2, y: 2 },
          { x: -3, y: 2 },
          { x: -4, y: 2 },
          { x: -5, y: 2 }]
    it 'all right moves range from x: 3, y: 2 to x: 9, y: 2 and are ordered', ->
      moves = move.allRight
      expect(moves.length).toEqual 7
      expect(moves.map (x) -> x.fn(_f.clone pos)).toEqual [
          { x: 3, y: 2 },
          { x: 4, y: 2 },
          { x: 5, y: 2 },
          { x: 6, y: 2 },
          { x: 7, y: 2 },
          { x: 8, y: 2 },
          { x: 9, y: 2 }]
    it 'all ne moves range from x: 3, y: 3 to x: 9, y: 9 and are ordered', ->
      moves = move.allNE
      expect(moves.length).toEqual 7
      expect(moves.map (x) -> x.fn(_f.clone pos)).toEqual [
          { x: 3, y: 3 },
          { x: 4, y: 4 },
          { x: 5, y: 5 },
          { x: 6, y: 6 },
          { x: 7, y: 7 },
          { x: 8, y: 8 },
          { x: 9, y: 9 }]
    it 'all nw moves range from x: 1, y: 3 to x: -5, y: 9 and are ordered', ->
      moves = move.allNW
      expect(moves.length).toEqual 7
      expect(moves.map (x) -> x.fn(_f.clone pos)).toEqual [
          { x:  1, y: 3 },
          { x:  0, y: 4 },
          { x: -1, y: 5 },
          { x: -2, y: 6 },
          { x: -3, y: 7 },
          { x: -4, y: 8 },
          { x: -5, y: 9 }]
    it 'all se moves range from x: 3, y: 1 to x: 9, y: -5 and are ordered', ->
      moves = move.allSE
      expect(moves.length).toEqual 7
      expect(moves.map (x) -> x.fn(_f.clone pos)).toEqual [
          { x: 3, y:  1 },
          { x: 4, y:  0 },
          { x: 5, y: -1 },
          { x: 6, y: -2 },
          { x: 7, y: -3 },
          { x: 8, y: -4 },
          { x: 9, y: -5 }]
    it 'all sw moves range from x: 1, y: 1 to x: -5, y: -5 and are ordered', ->
      moves = move.allSW
      expect(moves.length).toEqual 7
      expect(moves.map (x) -> x.fn(_f.clone pos)).toEqual [
          { x:  1, y:  1 },
          { x:  0, y:  0 },
          { x: -1, y: -1 },
          { x: -2, y: -2 },
          { x: -3, y: -3 },
          { x: -4, y: -4 },
          { x: -5, y: -5 }]
