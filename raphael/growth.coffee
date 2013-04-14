WIDTH = 500
XPADDING = 50
YPADDING = 25
HEIGHTUNIT = 60
HEIGHT = HEIGHTUNIT * 3 + (2 * YPADDING)
X0 = XPADDING
Y0 = HEIGHT - YPADDING
UNIT = WIDTH - 2 * XPADDING
RECTWIDTH = 30
DISTANCE = UNIT - RECTWIDTH
PROGRESSION = [
  'green'
  'teal'
  'blue'
  'violet'
  'red'
  'orange'
  'yellow'
]

UNFOCUS_DELAY = 500
START_DELAY = 500
SEQUENCE_DELAY = 1000
RESTART_DELAY = 3000
JUMP_DURATION = 300
TICK_DELAY = 500
WALK_DURATION = 2000
FINAL_WALK = 3000
FINAL_HOLD = 5000


growers = []


class Growth extends Uriel.Diagram
  constructor: (elem) ->
    super elem, WIDTH, HEIGHT

    @paper.ca.exp = (t) ->
      dy = HEIGHTUNIT * (Math.pow(Math.E, t) - 1)
      attrs = {y: Y0 - HEIGHTUNIT - dy, height: dy}

    @compounds = @elem.data('compounds') ? 1
    @compounds = [@compounds] unless _.isArray @compounds
    @axis [X0, Y0], unit: UNIT, to: new Uriel.Bound(1, false), labels: false, tickType: false
    @guides= @paper.set @guide(1), @guide(2), @guide(3)
    @principle = @paper.rect(X0, Y0 - HEIGHTUNIT, RECTWIDTH, HEIGHTUNIT)
    @principle.node.setAttribute('class', 'green')
    @dollars = @paper.text(X0 + RECTWIDTH / 2, Y0 - HEIGHTUNIT / 2, '$')
    @dollars.node.removeAttribute('font')
    @dollars.node.setAttribute('style', 'font-size:20px;')
    @dollars.node.setAttribute('class', 'green')
    @interest = []
    @timeouts = []
    growers.push(this)
    @defocus()
    @onView @focus, UNFOCUS_DELAY, offset: (->
      ($(window).height() / 2)
    ), triggerOnce: false

  defocus: =>
    @elem.addClass('inactive')
    @principle.stop()
    @dollars.stop()
    clearTimeout(t) for t in @timeouts
    elem.stop() for elem in @interest

  focus: =>
    return unless @elem.is('.inactive')
    grower.defocus() for grower in growers when grower isnt this
    @elem.removeClass('inactive')
    @principle.attr x: X0
    @dollars.attr x: X0 + RECTWIDTH / 2
    elem.remove() for elem in @interest
    @timeouts.push setTimeout((=> @do(0)), START_DELAY)

  guide: (n) =>
    h = n * HEIGHTUNIT
    path = @paper.path("M#{X0} #{Y0 - h} l#{UNIT} 0")
    path.node.setAttribute 'class', 'guide'
    path

  do: (index) =>
    index = index % @compounds.length
    m = @compounds[index]
    @principle.attr x: X0
    @dollars.attr x: X0 + RECTWIDTH / 2
    elem.remove() for elem in @interest
    execute = => if m == 0 then @continuous() else @tick(0, m)
    @timeouts.push setTimeout(execute, SEQUENCE_DELAY)

  tick: (n, m) =>
    if n >= m
      @timeouts.push setTimeout((=> @do(@compounds.indexOf(m) + 1)), RESTART_DELAY)
      return
    delta = DISTANCE / m
    newX = X0 + ((n+1) * delta)
    t = WALK_DURATION / m
    canvas = this
    compounder = (-> canvas.compound(this, n, m))
    anim = @principle.animate {x: newX}, t, 'linear', compounder
    @dollars.animateWith @principle, anim, {x: newX + RECTWIDTH / 2}, t, 'linear'
    @accumulator = 0
    # We're going to me modifying the set in-place.
    interest = (elem for elem in @interest)
    elem.animateWith(@principle, anim, {x: newX}, t, 'linear', compounder) for elem in interest

  compound: (me, n, m) =>
    x = me.attr 'x'

    myClass = me.node.getAttribute 'class'
    myIndex = PROGRESSION.indexOf(myClass)
    myHeight = me.attr 'height'
    myY = me.attr 'y'
    myNewY = myY - @accumulator

    yourIndex = myIndex + 1
    throw "Can't compound that much!" if yourIndex >= PROGRESSION.length
    yourClass = PROGRESSION[yourIndex]
    yourHeight = myHeight / m
    yourStartY = myY
    yourEndY = myNewY - yourHeight
    you = @paper.rect(x, yourStartY, RECTWIDTH, yourHeight)
    you.node.setAttribute 'class', yourClass
    you.toBack()
    @guides.toBack()
    @accumulator += yourHeight
    @interest.splice(@interest.indexOf(me) + 1, 0, you)

    callback = if myIndex == 0 then @next(n, m) else null
    anim = me.animate {y: myNewY}, JUMP_DURATION, 'backOut', callback
    you.animateWith me, anim, {y: yourEndY}, JUMP_DURATION, 'backOut'

  next: (n, m) =>
    () => @timeouts.push setTimeout((=> @tick(n + 1, m)), TICK_DELAY)

  continuous: =>
    interest = @paper.rect X0, Y0 - HEIGHTUNIT, RECTWIDTH, 0
    interest.attr exp: 0, fill: '#009999', stroke: '#006363'
    finish = => @timeouts.push setTimeout (=> @do(@compounds.length)), FINAL_HOLD
    # TODO: exponential curve
    attrs = {x: X0 + DISTANCE, fill: '#7109AA', stroke: '#48036F', exp: 1}
    anim = @principle.animate {x: X0 + DISTANCE}, FINAL_WALK, finish
    @dollars.animateWith @principle, anim, {x: X0 + DISTANCE + RECTWIDTH / 2}, FINAL_WALK
    interest.animateWith @principle, anim, attrs, FINAL_WALK
    @interest.push interest


$ -> Uriel.diagram('growth', Growth)
