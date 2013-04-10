width = 500
height = 200
radius = 45
padding = 5

circumference = τ * radius
middle = height / 2
zx = padding + radius
zy = middle + radius
tx = width - 2 * radius
ty = radius

class Unroller extends Diagram
  start: =>
    @isDiameterLine = @elem.data('diameter') || false
    @stopEarly = @elem.data('pistop') || false
    counter = @elem.data('counter') || false
    @lineLength = if @isDiameterLine then 2 * radius else radius
    tickCount = if @isDiameterLine then 4 else 8
    capFraction = if @isDiameterLine then 1/2 else 1
    @axis(zx - 0.5, zy, @lineLength, tickCount, capFraction: capFraction)
    @circle = @paper.circle()
    @outline = @paper.path().attr 'stroke-width': 2
    $(@outline.node).attr 'class': 'colored', 'style': 'fill:none'
    @laid = @paper.path().attr 'stroke-width', 2
    $(@laid.node).attr 'class', 'colored'
    @line = @paper.path().attr 'stroke-width', 1
    $(@line.node).attr 'class', 'colored'
    @counter = if counter then @paper.text(tx, ty, 0.toFixed 6) else false
    @reset()
    setTimeout @begin, 3000

  reset: =>
    @circle.attr
      cx: zx
      cy: zy - radius
      r: radius
      opacity: 0
      'stroke-width': 2
      transform: ''
    @outline.attr
      partialCircle: [zx, zy - radius, radius, .9999, -1/4]
      opacity: 0
    @laid.attr path: new Path(zx, zy).draw(0.01, 0).string
    @line.attr opacity: 1, path: new Path(zx + 0.5, zy).draw(@lineLength, 0).string
    @counter?.attr?(turnText: 0, opacity: 0)

  begin: =>
    @reset()
    @line.animate transform: "r-90 #{zx + 0.5} #{zy}", 1000, '<>', @fadeIn

  fadeIn: =>
    a = @circle.animate opacity: 1, 1000, '<', @roll
    @counter?.animateWith?(@circle, a, opacity: 1, 1000, '<')
    uplen = if @isDiameterLine then radius else 0
    @line.attr transform: '', turnRotate: [zx, zy - radius, radius, uplen, -1/4]

  roll: =>
    @circle.attr 'stroke-width': 0
    @outline.attr opacity: 1
    @laid.attr opacity: 1

    ease = if @stopEarly then '<' else '<>'
    duration = if @stopEarly then 2500 else 5000
    uplen = if @isDiameterLine then radius else 0
    turns = if @stopEarly then 1/2 else 1
    distance = turns * circumference

    a = @circle.animate transform: "t#{distance} 0", duration, ease, @pause
    @line.animateWith(
        @circle, a
        turnRotate: [zx + distance, zy - radius, radius, uplen, -1/4 - turns]
        duration, ease)
    @outline.animateWith(
        @circle, a
        partialCircle: [zx + distance, middle, radius, 1 - turns, -1/4]
        duration, ease)
    @laid.animateWith(
        @circle, a
        path: new Path(zx, zy).draw(distance, 0).string
        duration, ease)
    @counter?.animateWith?(@circle, a, turnText: turns, duration, ease)

  pause: => setTimeout @fadeOut, if @stopEarly then 5500 else 3000

  fadeOut: =>
    a = @circle.animate opacity: 0, 1000, '<', @wait
    @laid.animateWith @circle, a, opacity: 0, 1000, '<'
    @line.animateWith @circle, a, opacity: 0, 1000, '<'
    @outline.animateWith @circle, a, opacity: 0, 1000, '<'
    @couter?.animateWith @circle, a, opacity: 0, 1000, '<'

  wait: => setTimeout @begin, 1000


diagram('unroll', Unroller, width, height)
