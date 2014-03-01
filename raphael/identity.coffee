UNIT = 90

progression = [
  'red'
  'orange'
  'gold'
  'amber'
  'yellow'
  'celadon'
  'green'
  'teal'
  'blue'
  'navy'
  'violet'
  'magenta'
]

class ComplexPlane extends Uriel.Plane
  constructor: (elem, options={}) ->
    options.unit ?= UNIT
    super elem, options

  setup: =>
    @rule([1, 0], [1, 1]).element.toBack()
    @point [1, 1], progression[0]
    @point([1, 0], progression[1]).dot.element.attr(r: 2)
    @text [1.2, 1.1], ['1 + 1', {text: 'i', 'font-style': 'italic'}]

  makeHorizontalAxis: =>
    super
      from: -2
      to: 2
      tickType: 'full'
      capLength: 1/3
      adjustTick: (num, t) ->
        if num in [-2, 2] then [1/2, t] else true
      labels: (num) ->
        if num in [-1, 1] then num else false

  makeVerticalAxis: =>
    super
      from: -2
      to: 2
      textOffset: 10
      capLength: 1/3
      adjustTick: (num, t) ->
        if num in [-2, 2] then [1/2, t] else true
      tickType: 'full'
      labels: (num) ->
        return {text: 'i', 'font-style': 'italic'} if num is 1
        return {text: '-i', 'font-style': 'italic'} if num is -1
        return false


class Compound extends ComplexPlane
  constructor: (elem) ->
    unit = parseFloat($(elem).data('unit') ? 1) * UNIT
    super elem, unit: unit
    @guide(1).element.toBack() if @elem.data('circle')
    @factor = @elem.data('factor') ? 1
    @scales = @elem.data('scales') ? false
    @factor = Math.PI if @factor == 'pi'
    @points = @paper.set()
    @rules = @paper.set()
    @lines = @paper.set()
    @timeouts = []
    @n = @elem.data('n')
    @current_index = false
    if _.isArray @n
      @draw(0)
      doAll = (=> @timeouts.push(setTimeout(@drawAll, 1000)))
      @elem.waypoint(doAll, triggerOnce: true, offset: 'bottom-in-view')
    else @draw(@n)
    @scale(@scales[0]) if @scales?[0]

  scale: (factor) =>
    width = @width / factor
    height = @height / factor
    x = (@width - width) / 2
    y = (@height - height) / 2
    @paper.setViewBox(x, y, width, height)

  drawAll: () =>
    @current_index = 1 unless _.isNumber @current_index
    i = @current_index
    @current_index = (@current_index + 1) % @n.length
    @draw(i)

  draw: (i) =>
    clearTimeout(t) for t in @timeouts
    @timeouts = []
    elem.remove() for elem in @points
    elem.remove() for elem in @rules
    elem.remove() for elem in @lines
    @label.element.remove() if @label
    if _.isArray @n
      m = @n[i]
      if @scales?[i] then @scale(@scales[i])
      else if @scales then @scale(1)
    else m = i
    @label = @text [2, 2], [{text: 'n', 'font-style': 'italic'}, " = #{m}"]
    @doPoint(0, new Complex(1, 0), null, m)

  doPoint: (n, prev, prevDot, m) ->
    prevDot.attr(r: 2) if prevDot
    current = new Complex(1, @factor/m).pow(n)
    index = (m - n) % progression.length
    @rules.push @rule([prev.real, prev.im], [current.real, current.im]).element
    @points.toFront()
    point = @point([current.real, current.im], progression[index])
    @points.push point.dot.element
    @lines.push point.line.element
    t = 500 / m
    t = 0 unless _.isNumber @current_index
    if n < m
      doNext = (=> @doPoint(n+1, current, point.dot.element, m))
    else if _.isNumber(@current_index)
      doNext = @drawAll
      t += 500
      t += 2000 if @current_index is 0
    else doNext = false
    @timeouts.push(setTimeout(doNext, t)) if doNext

  setup: =>

class Tangents extends Uriel.Plane
  constructor: (elem) ->
    super elem, unit: UNIT

  setup: =>
    @rule [1, -3], [1, 3]
    @paper.ca.tangent = ((turns) =>
      turns = 0 if turns is 1
      u = Math.cos(τ * turns)
      v = Math.sin(τ * turns)
      [zx, zy] = @origin
      [x, y] = @pt([u, v])
      topOff = [x + (5 * v * @unit), y + (5 * u * @unit)]
      botOff = [x - (5 * v * @unit), y - (5 * u * @unit)]
      return path: "M#{topOff} L#{botOff}"
    )
    radius = @path "M#{@origin} L#{@pt([1, 0])}", class: 'colored'
    circle = @circle [0, 0], 1 * UNIT, class: 'colored line'
    path = @path "M#{@pt([1, 3])} L#{@pt([1, -3])}", class: 'teal'
    path.element.attr tangent: 0
    dot = @circle [1, 0], 2, class: 'teal'
    dotAnim = Raphael.animation(transform: "R-360 #{@origin}", 10000, 'linear').repeat(Infinity)
    tangentAnim = Raphael.animation(tangent: 1, 10000, 'linear').repeat(Infinity)
    dot.element.animate dotAnim
    path.element.animateWith dot.element, dotAnim, tangentAnim
    radius.element.animateWith dot.element, dotAnim, dotAnim


  makeHorizontalAxis: =>
    super
      from: -2
      to: 2
      tickType: false
      capLength: 1/3
      labels: false

  makeVerticalAxis: =>
    super
      from: -2
      to: 2
      capLength: 1/3
      tickType: false
      labels: false



$ ->
  Uriel.diagram('complex-plane', ComplexPlane)
  # Uriel.diagram('compound', Compound)
  # Uriel.diagram('tangents', Tangents)
