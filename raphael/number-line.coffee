width = 500
height = 50
padding = 40
unit = 35

class NumberLine extends Diagram
  start: =>
    numberOnly = @elem.data('only-numbers') || false
    positives = @elem.data('positives') || false
    x = if positives then padding + unit else width / 2
    y = height / 2
    @axis x, y,
      unit: unit
      tickType: if numberOnly then ' ' else 'T'
      textOffset: if numberOnly then 1 else null
      from: if positives then null else -5
      to: if positives then 10 else 5
      zero: if positives then 1 else 0
      zeroTick: not positives


class NumberPlane extends Diagram
  start: =>
    @zero = @paper.text(width/2, width/2 + 12, '0')
    @axis width/2, width/2,
      unit: unit
      from: -5
      to: 5
      zeroLabel: false
    [@geometry, @labels] = @axis width/2, width/2,
      unit: unit
      from: -5
      to: 5
      tickType: 'L'
      labels: -> '?'
      zeroTick: 0
      zeroLabel: false
    @labels.attr opacity: 0
    @elem.waypoint(
      callbackAfter(@expand, 1000)
      offset: 'bottom-in-view'
      triggerOnce: true)

  expand: =>
    a = @geometry.animate(
      transform: ['r', -90, width/2, width/2]
      1500, '<'
      callbackAfter(@fadeOut, 5000))
    @labels.animateWith(
      @geometry, a
      transform: ['r', -90, width/2, width/2, 'r', 90, 't', -21, 0]
      opacity: 1
      1500, '<')
    @zero.animateWith(
      @geometry, a
      transform: ['t', -8, 0]
      1500, '<')

  fadeOut: =>
    a = @geometry.animate {opacity: 0}, 1000, '<>', callbackAfter(@restart, 2000)
    @labels.animateWith @geometry, a, opacity: 0, 1000, '<>'
    @zero.animateWith @geometry, a, transform: 0, 1000, '<>'

  restart: =>
    @geometry.attr transform: '', opacity: 1
    @labels.attr opacity: 0, transform: ''
    @zero.attr transform: ''
    @expand()

class ComplexPlane extends Diagram
  start: =>
    @x0 = width/2
    @y0 = width/2
    @unit = unit
    @zero = @paper.text(width/2 - 8, width/2 + 12, '0')
    @real = @axis width/2, width/2,
      unit: @unit
      from: -5
      to: 5
      zeroLabel: false
    @complex = @axis width/2, width/2,
      unit: @unit
      from: -5
      to: 5
      zeroLabel: false
      turns: 1/4
      labels: (num) -> [num, {text: 'i', 'font-style': 'italic'}]
      tickType: 'L'
      swapLabels: true
      textOffset: 10
    @rule 0, 3, 2, 3
    @rule 2, 0, 2, 3
    @point 2, 3, 'red'
    @text @x(3) - 8, @y(3) + 3, ['2 + 3', {text: 'i', 'font-style': 'italic'}]

  x: (x) => @x0 + x * @unit
  y: (y) => @y0 - y * @unit
  faded: '#cccccc'

  rule: (x1, y1, x2, y2) =>
    x1 = @x0 + x1 * @unit
    y1 = @y0 - y1 * @unit
    x2 = @x0 + x2 * @unit
    y2 = @y0 - y2 * @unit
    path = @paper.path(['M', x1, y1, 'L', x2, y2]).attr 'stroke', @faded
    $(path.node).attr 'stroke-dasharray': '5,5'

  point: (x, y, color) =>
    path = @paper.path(['M', @x0, @y0, 'l', x * @unit, -y * @unit])
    $(path.node).attr class: color
    dot = @paper.circle(@x0 + x * @unit, @y0 - y * @unit, 4)
    $(dot.node).attr class: color
    [path, dot]

class PolarPlane extends ComplexPlane
  start: =>
    @x0 = width/2
    @y0 = width/2
    @unit = unit / 2
    @guide(2)
    @guide(4)
    @guide(6)
    @guide(8)
    @guide(10)
    @real = @axis width/2, width/2,
      unit: @unit
      from: -10
      to: 10
      step: 2
      doTick: ((num) -> num >= 0)
      zeroLabel: false
    @complex = @axis width/2, width/2,
      unit: @unit
      from: -10
      to: 10
      step: 2
      turns: 1/4
      labels: false
      tickType: false
    @point(3, 0, 'red')
    @point(0, 2, 'blue')
    [@rpath, @rdot] = @point(3, 0, 'violet')
    @result = @paper.set(@rpath, @rdot)
    @result.attr opacity: 0
    @commentary = @text(@x(9), @y(9), '3 ↺ zero × 2 ↺ quarter')
    @elem.waypoint(
      callbackAfter(@fadeIn, 1000)
      offset: 'bottom-in-view'
      triggerOnce: true)

  guide: (len) =>
    guide = @paper.circle(@x0, @y0, len * @unit).attr stroke: @faded, 'stroke-width': 1
    $(guide.node).attr 'stroke-dasharray', '5,5'

  reset: =>
    @commentary.attr text: '3 ↺ zero × 2 ↺ quarter'
    @result.attr transform: '', opacity: 0
    @rdot.attr cx: @x(3)
    @rpath.attr path: ['M', @x0, @x0, 'l', 3 * @unit, 0]
    setTimeout @fadeIn, 4000

  fadeIn: =>
    @commentary.attr {text: '3 × 2'}
    @result.animate opacity: 1, 1000, '<>', @scale

  scale: =>
    a = @rdot.animate {transform: ['t', 3 * @unit, 0]}, 1000, '<>', callbackAfter(@turn, 2000)
    @rpath.animateWith @rdot, a, path: ['M', @x0, @y0, 'l', 6 * @unit, 0], 1000, '<>'

  turn: =>
    @commentary.attr text: 'zero turns + a quarter turn'
    @rdot.attr transform: '', cx: @x(6)
    @result.animate {transform: ['r', -90, @x0, @y0]}, 2000, '<>', @pause

  pause: =>
    setTimeout (=> @commentary.attr text: '= 6 ↺ ¼'), 1000
    setTimeout @reset, 5000


class OnePlane extends PolarPlane
  start: =>
    @x0 = width/2
    @y0 = width/2
    @unit = unit * 1.5
    @guide(2)
    @guide(3)
    @real = @axis width/2, width/2,
      unit: @unit
      from: -3
      to: 3
      doTick: ((num) -> num >= 0)
      labels: false
    @complex = @axis width/2, width/2,
      unit: @unit
      from: -3
      to: 3
      turns: 1/4
      labels: false
      tickType: false
    @magnitude(1)
    oneTurn = @text(@x(1.5), @y(0), '1↺0')
    @paper.ca.oneTurn = (turns) =>
      if turns == 1
        return {oneTurn: 0}
      x = @x(1.5 * Math.cos(τ * turns))
      y = @y(1.5 * Math.sin(τ * turns))
      {
        x: x
        y: y
        text: "1↺#{turns.toFixed(2)}"
      }
    oneTurn.attr oneTurn: 0
    oanim = Raphael.animation(oneTurn: 1, 10000).repeat(Infinity)
    oneTurn.animate(oanim)

    point = @circle(class: 'colored')
    point.attr cx: @x(1), cy: @y(0), r: 2
    panim = Raphael.animation(transform: ['R', -360, @x0, @y0], 10000).repeat(Infinity)
    point.animateWith(oneTurn, oanim, panim)


  magnitude: (len) =>
    guide = @paper.circle(@x0, @y0, len * @unit).attr stroke: @faded, 'stroke-width': 1
    $(guide.node).attr class: 'colored', style: 'fill: none'

$ ->
  diagram('number-line', NumberLine, width, height)
  diagram('number-plane', NumberPlane, width, width)
  diagram('complex-plane', ComplexPlane, width, width)
  diagram('polar-plane', PolarPlane, width, width)
  diagram('one-plane', OnePlane, width, width)
