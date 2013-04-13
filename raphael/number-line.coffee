LARGE = 500
SMALL = 50
PADDING = 40
UNIT = 35

class NumberLine extends Uriel.Diagram
  constructor: (elem, width=LARGE, height=SMALL) ->
    super elem, width, height
    numberOnly = @elem.data('only-numbers') || false
    positives = @elem.data('positives') || false
    x = if positives then PADDING + UNIT else width / 2
    y = height / 2
    @axis [x, y],
      unit: UNIT
      tickType: if numberOnly then false else null
      drawLine: not numberOnly
      textOffset: if numberOnly then 2 else null
      from: if positives then null else -5
      to: if positives then 10 else 5
      zero: if positives then 1 else 0


class NumberPlane extends Uriel.Diagram
  constructor: (elem, width=LARGE, height=LARGE) ->
    super elem, width, height
    [zx, zy] = [width / 2, height / 2]
    zero = @text [zx, zy + 12], '0'
    real = @axis [zx, zy],
      unit: UNIT
      from: -5
      to: 5
      labels: (num) -> if num is 0 then false else num
    imaginary = @axis [zx, zy],
      unit: UNIT
      from: -5
      to: 5
      tickType: 'top'
      adjustTick: (num) -> num isnt 0
      labels: (num) -> if num is 0 then false else '?'
    initial = [
      [imaginary.elements.geometry, transform: '', opacity: 1]
      [imaginary.elements.labels, transform: '', opacity: 0]
      [zero, transform: '']
    ]
    expand = @animate([
      [zero, transform: ['t', -8, 0]]
      [imaginary.elements.geometry, transform: ['r', -90, zx, zy]]
      [imaginary.elements.labels, {
        transform: ['r', -90, zx, zy, 'r', 90, 't', 0]
        opacity: 1}]
    ], 1500, '<')
    close = @animate(initial, 750, '>')
    @recipe(initial, [1000, expand, 5000, close], 8000).triggerOnView(1000)

class ComplexPlane extends Uriel.Plane
  constructor: (elem) ->
    super elem, width: LARGE, height: LARGE, unit: UNIT
    @rule [2, 3], [0, 3]
    @rule [2, 3], [2, 0]
    @text [2.6, 3.2], ['2 + 3', {text: 'i', 'font-style': 'italic'}]
    @point [2, 3], 'red'

  labelZero: =>
    @text [-0.33, -0.4], 0

  makeVerticalAxis: =>
    super
      textOffset: 10
      labels: (num) ->
        if num is 0 then false else [num, {text: 'i', 'font-style': 'italic'}]

  point: (pt, color) =>
    @line [0, 0], pt, class: color
    @circle pt, 4, class: color

class PolarPlane extends Uriel.Diagram
  constructor: (elem, width=LARGE, height=LARGE) ->
    super elem, width, height
    @x0 = width / 2
    @y0 = height / 2
    @unit = UNIT / 2
    @guide(2)
    @guide(4)
    @guide(6)
    @guide(8)
    @guide(10)
    @real = @axis [@x0, @y0],
      unit: @unit
      from: -10
      to: 10
      step: 2
      labels: (num) -> if num is 0 then false else num
    @imaginary = @axis [@x0, @y0],
      unit: @unit
      from: -10
      to: 10
      step: 2
      labels: (num) -> if num is 0 then false else [num, {text: 'i', 'font-style': 'italic'}]
      turns: 1/4
      tickType: 'top'
      textOffset: 10
    @point(3, 0, 'red')
    @point(0, 2, 'blue')

    [rpath, rdot] = @point 3, 0, 'violet'
    commentary = @text [@x(9), @y(9)], ''
    result = @group([rpath, rdot])

    initial = [
      [result, transform: '', opacity: 0]
      [commentary, text: '']
      [rdot, cx: @x(3), cy: @y(0)]
      [rpath, path: ['M', @x0, @y0, 'l', 3 * @unit, 0]]
    ]
    problem = [
      [commentary, text: '3 ↺ zero × 2 ↺ quarter']
    ]
    fadeIn = @animate([
      [result, opacity: 1]
    ], 300, '<>')
    preScale = [
      [commentary, text: '3 × 2']
    ]
    scale = @animate([
      [rdot, transform: ['t', 3 * @unit, 0]]
      [rpath, path: ['M', @x0, @y0, 'l', 6 * @unit, 0]]
    ], 1000, '<>')
    preTurn = [
      [commentary, text: 'zero turns + a quarter turn']
      [rdot, transform: '', cx: @x(6)]
    ]
    turn = @animate([
      [result, transform: ['r', -90, @x0, @y0]]
    ], 2000, '<>')
    hold = [
      [commentary, text: '= 6 ↺ ¼']
      [result, transform: ''],
      [rdot, cx: @x(0), cy: @y(6)]
      [rpath, path: ['M', @x0, @y0, 'L', @x(0), @y(6)]]
    ]
    preFallDown = [
      [commentary, text: '']
    ]
    fallDown = @animate([
      [result, transform: ['t', 0, 6 * @unit], opacity: .8]
    ], 500, 'backOut')
    fadeOut = @animate([[result, opacity: 0]], 200)
    recipe = @recipe(initial, [
      1000, problem, 3000, fadeIn, 1000, preScale, 500, scale, 1500, preTurn, 500, turn, 500, hold, 5000, preFallDown, fallDown, fadeOut
    ], 1000)
    recipe.triggerOnView()

  guide: (len) =>
    @circle [@x0, @y0], len * @unit, class: 'guide'

  # TODO: factor these out. They're duplicated.
  x: (x) => @x0 + x * @unit
  y: (y) => @y0 - y * @unit

  point: (x, y, color) =>
    path = @path ['M', @x0, @y0, 'l', x * @unit, -y * @unit], class: color
    dot = @circle [@x0 + x * @unit, @y0 - y * @unit], 4, class: color
    [path, dot]


class OnePlane extends Uriel.Diagram
  constructor: (elem, width=LARGE, height=LARGE) ->
    super elem, width, height
    @x0 = width / 2
    @y0 = height / 2
    @unit = UNIT * 1.5
    @guide(2)
    @guide(3)
    @real = @axis [@x0, @y0],
      unit: @unit
      from: -3
      to: 3
      labels: (num) -> if num > 1 then num else false
      adjustTick: (num) -> if num > 1 then true else false
    @imaginary = @axis [@x0, @y0],
      unit: @unit
      from: -3
      to: 3
      turns: 1/4
      labels: false
      tickType: false
    @magnitude(1)
    @register
      oneTurn: (turns) =>
        if turns == 1
          return {oneTurn: 0}
        x = @x(1.5 * Math.cos(τ * turns))
        y = @y(1.5 * Math.sin(τ * turns))
        {
          x: x
          y: y
          text: "1↺#{turns.toFixed(2)}"
        }

    oneTurn = @text [@x(1.3), @y(0)], '1↺0'
    point = @circle [@x(1), @y(0)], 2, class: 'colored'

    initial = [[oneTurn, oneTurn: 0]]
    go = @animate([
      [oneTurn, oneTurn: 1]
      [point, transform: ['R', -360, @x0, @y0]]
    ], 10000, 'linear', Infinity)
    @recipe(initial, [go]).trigger()


  magnitude: (len) =>
    @circle [@x0, @y0], len * @unit, class: 'colored line'

  # TODO: Copied.
  guide: (len) => @circle [@x0, @y0], len * @unit, class: 'guide'
  x: (x) => @x0 + x * @unit
  y: (y) => @y0 - y * @unit

$ ->
  Uriel.diagram('number-line', NumberLine)
  Uriel.diagram('number-plane', NumberPlane)
  Uriel.diagram('complex-plane', ComplexPlane)
  Uriel.diagram('polar-plane', PolarPlane)
  Uriel.diagram('one-plane', OnePlane)
