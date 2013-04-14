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
    initial = @animation(
      [imaginary.elements.geometry, transform: '', opacity: 1]
      [imaginary.elements.labels, transform: '', opacity: 0]
      [zero, transform: ''])
    expand = @animation(
      [zero, transform: ['t', -8, 0]]
      [imaginary.elements.geometry, transform: ['r', -90, zx, zy]]
      [imaginary.elements.labels,
        transform: ['r', -90, zx, zy, 'r', 90, 't', 0]
        opacity: 1])
    @recipe(initial(), [
      1000, expand(1500, '<')
      5000, initial(750, '>')
    ], 8000).triggerOnView()

class ComplexPlane extends Uriel.Plane
  constructor: (elem) -> super elem, unit: UNIT

  setup: =>
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

class PolarPlane extends Uriel.Plane
  constructor: (elem) -> super elem, unit: UNIT / 2

  makeHorizontalAxis: =>
    super
      from: -10
      to: 10
      step: 2

  makeVerticalAxis: =>
    super
      from: -10
      to: 10
      step: 2
      textOffset: 10
      labels: (num) ->
        if num is 0 then false else [num, {text: 'i', 'font-style': 'italic'}]

  drawGuides: =>
    @guide(2)
    @guide(4)
    @guide(6)
    @guide(8)
    @guide(10)

  setup: =>
    @point [3, 0], 'red'
    @point [0, 2], 'blue'
    result = @point [3, 0], 'violet'
    commentary = @text [9, 9]

    initial = @animation(
      result.moveTo([3, 0])
      [result, transform: '', opacity: 0]
      [commentary, text: '3↺0 ∗ 2↺¼', opacity: 0]
    )
    problem = @animation(
      [commentary, opacity: 1]
    )
    fadeIn = @animation(
      [result, opacity: 1]
      [commentary, text: '3 × 2']
    )
    scale = @animation(
      result.moveTo([6, 0])
    )
    rotate = @animation(
      [result, transform: "R-90 #{@origin}", delay: 1/2]
      [commentary, text: '0 turns rotated ¼ turns']
    )
    answer = @animation(
      [commentary, text: '= 6↺¼']
      [result, transform: '']
      result.moveTo([0, 6])
    )
    drop = @animation(
      result.moveTo([0, 0])
      [result, opacity: 0]
      [commentary, opacity: 0]
    )

    @recipe(initial(), [
      1000
      problem(500)
      2000
      fadeIn(500)
      scale(1000, '<')
      1000
      rotate(1000, '<')
      1000
      answer()
      4000
      drop(750, 'backOut')
    ], 2000).triggerOnView()


class OnePlane extends Uriel.Plane
  constructor: (elem) ->
    super elem, unit: UNIT * 1.5

  makeHorizontalAxis: =>
    super
      from: -3
      to: 3
      labels: (num) -> if num > 1 then num else false
      adjustTick: (num) -> if num > 1 then true else false

  makeVerticalAxis: =>
    super
      from: -3
      to: 3
      labels: false
      tickType: false

  drawGuides: =>
    @guide 2
    @guide 3

  setup: =>
    @circle [0, 0], @unit, class: 'colored line'
    ot = ((turns) =>
      return ot(0) if turns is 1
      [x, y] = @pt([1.5 * Math.cos(τ * turns), 1.5 * Math.sin(τ * turns)])
      {x: x, y: y, text: "1↺#{turns.toFixed(2)}"}
    )
    @register oneTurn: ot

    oneTurn = @text [1.3, 0], '1↺0'
    point = @circle [1, 0], 2, class: 'colored'

    oneTurn.apply oneTurn: 0
    oneTurnAnim = Raphael.animation(oneTurn: 1, 10000, 'linear').repeat(Infinity)
    pointAnim = Raphael.animation(transform: "R-360 #{@origin}", 10000, 'linear').repeat(Infinity)
    oneTurn.element.animate(oneTurnAnim)
    point.element.animateWith(oneTurn.element, oneTurnAnim, pointAnim)

$ ->
  Uriel.diagram('number-line', NumberLine)
  Uriel.diagram('number-plane', NumberPlane)
  Uriel.diagram('complex-plane', ComplexPlane)
  Uriel.diagram('polar-plane', PolarPlane)
  Uriel.diagram('one-plane', OnePlane)
