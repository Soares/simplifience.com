# Annoying constants.
SVG_DOCTYPE = 'http://www.w3.org/2000/svg'

# Useful global simplifience constants.
@τ = 2 * Math.PI;


# Global namespace for Uriel.
@Uriel =
  diagram: (classname, diagram, width=null, height=null) ->
    $(".#{classname}").each -> new diagram(this, width, height)


class Uriel.Bound
  constructor: (@end, @open = true) ->


class Uriel.Element
  constructor: (@element, attrs) ->
    @apply attrs

  apply: (attrs) =>
    # Copy the attrs so that they may be reused.
    attrs = _.extend({}, attrs)
    if _.isArray(attrs.class)
      attrs.class = attrs.class.join(' ')
    for underlying in ['class', 'style']
      if attrs[underlying]?
        @element.node.setAttribute(underlying, attrs[underlying])
        delete attrs[underlying]
    # Ignored by apply, used by animations.
    # We ignore it here so that animation setups can be run in reverse.
    delete attrs.delay
    @element.attr(attrs)
    this

  animate: (attrs, controls={}) =>
    if attrs.delay?
      delay = attrs.delay
      attrs = _.extend({}, attrs)
      delete attrs.delay
    else delay = 0
    callback = unless controls.master then controls.callback else null
    duration = controls.duration
    anim = Raphael.animation(attrs, duration, controls.easing, callback)
    anim = anim.delay(delay) if delay
    anim = anim.repeat(controls.repeat) if controls.repeat?
    if controls.master
      @element.animateWith(controls.master[0], controls.master[1], anim)
    else
      @element.animate(anim)
      controls.master = [@element, anim]


class Uriel.Path extends Uriel.Element
  # Remove the shitty Raphael presets in favor of my own shitty CSS presets.
  constructor: (paper, description=null, attrs={}) ->
    element = paper.path(description)
    element.node.removeAttribute('style')
    element.node.removeAttribute('fill')
    element.node.removeAttribute('stroke')
    super element, attrs


class Uriel.Circle extends Uriel.Element
  # Remove the shitty Raphael presets in favor of my own shitty CSS presets.
  constructor: (paper, x, y, r, attrs={}) ->
    element = paper.circle(x, y, r)
    element.node.removeAttribute('style')
    element.node.removeAttribute('fill')
    element.node.removeAttribute('stroke')
    super element, attrs


class Uriel.Text extends Uriel.Element
  # Raphael makes some stupid choices with its text elements.
  # SVG makes some stupid choices about text-anchoring in the middle.
  # As a result, make sure you change fonts-size with attrs instead of CSS!
  constructor: (paper, x, y, text, attrs={}) ->
    element = paper.text x, y, ''
    # Destroy empty tspan. We'll make our own.
    element.node.removeChild(element.node.lastChild)
    element.node.removeAttribute('style')
    element.node.removeAttribute('fill')
    element.node.removeAttribute('stroke')
    element.node.removeAttribute('font')
    attrs['font-size'] = 10 unless attrs['font-size']?
    fontSize = attrs['font-size']
    text = [text] unless _.isArray(text)
    element.node.appendChild(@tspan(part, fontSize)) for part in text
    # Apply font-size via element style. SVG is stupid.
    delete attrs['font-size']
    attrs['style'] = '' unless attrs['style']?
    attrs['style'] = "font-size:#{fontSize};#{attrs['style']}"
    super element, attrs

  tspan: (text, fontSize) =>
    tspan = document.createElementNS(SVG_DOCTYPE, 'tspan')
    if _.isObject(text)
      tspan.appendChild(document.createTextNode(text.text))
      delete text.text
      for key, val of text
        tspan.setAttribute(key, val)
    else
      tspan.appendChild(document.createTextNode(text))
    # A magic value that centers the text a bit better.
    # Employed shittily by SVG using bounding-box magic.
    # See raphael issue #491.
    tspan.setAttribute('dy', fontSize / 4)
    return tspan


class Uriel.Axis
  constructor: (@paper, @x0, @y0, options={}) ->
    options = _.defaults options,
      # Function to adjust specific ticks. tickType is one of 'top', 'bottom',
      # or 'full'.  The function should return [factor, type] where factor is
      # a scaling factor type is 'top', 'bottom', or 'full'.
      adjustTick: ((num, type) ->
        if num == options.zero and options.tickType
          if type == 'full' then [1.5, 'full'] else [1, 'full']
        else [1, type])
      arrowDimensions: [2, 1/2]  # [length (in unit), breadth (in tickHeight)]
      capLength: 1  # The length (in unit) of the axis after the last tick.
      classes:  {} # The classes for various components. See below.
      from: null  # Start at zero by default.
      labels: {}  # Map {num: string}. May also be (num) -> string|bool.
      step: 1  # May also be (num) -> bool
      swapLabels: false  # Place labels opposite ticks.
      # Axes anchor text in the middle. It would be more robust (from
      # a textOffset) point of view to anchor text at the top/bottom/left/right
      # (depending upon the orientation), but then axes could not easily be
      # rotated. You'll have to fiddle with textOffset to get it to look right
      # on a per-font basis.
      textOffset: 7  # End of tick to middle of text. May be (num) -> num.
      tickHeight: 4  # In pixels.
      tickType: 'bottom'  # One of 'top', 'bottom', 'full', or false
      drawLine: true
      to: new Uriel.Bound(10, true)  # Go to 10 (open bound) by default.
      turns: 0  # Rotation in turns. 0 is left-to-right, 1/4 is bottom-up, etc.
      unit: 25  # In pixels.
      zero: 0  # The "zero" point. The zero tick gets special treatment.

    # CSS classes for various components.
    @classes = _.defaults options.classes,
      # All options may be lists.
      all: 'axis',  # Applied to all elements.
      positive: 'positive',  # Applied to positive ticks, labels, and arrows.
      zero: 'zero',  # Applied to the zero tick and label.
      negative: 'negative',  # Applied to negative ticks, labels, and arrows.
      arrow: 'arrow',  # Applied to the arrows.
      axis: null,  # Applied to the axis line.

    # Various ways of grouping the component objects.
    @elements =
      geometry: new Uriel.Group(@paper)  # axis, ticks, and arrows
      ticks: new Uriel.Group(@paper)
      arrows: new Uriel.Group(@paper)
      labels: new Uriel.Group(@paper)

    # Copy global options into this.
    @unit = options.unit
    @zero = options.zero
    @tickHeight = options.tickHeight
    @tickType = options.tickType

    # Normalize the bounds.
    # Start at options.zero if they did't give another start point.
    options.from ?= new Uriel.Bound(@zero, false)
    # Make sure the bounds are bounds objects.
    if _.isNumber(options.from)
      options.from = new Uriel.Bound(options.from)
    if _.isNumber(options.to)
      options.to = new Uriel.Bound(options.to)

    # Determine the dimensions of the cap arrows.
    if options.arrowDimensions
      @arrowLength = options.arrowDimensions[0] * options.tickHeight
      @arrowBreadth = options.arrowDimensions[1] * options.tickHeight
    else
      @arrowLength = 0
      @arrowBreadth = 0

    # x-component of the turn.
    @asmuth = Math.cos(τ * options.turns)
    # y-component of the turn.
    @attitude = Math.sin(τ * options.turns)
    # This is the length of the extension line (before the first tick / after
    # the last tick) not including the little arrow.
    extensionLength = options.capLength * @unit - @arrowLength
    # Determine how many units are on each side of zero.
    # 1 2 |3| 4 5 6 7
    # posunits = 7 - 3 = 4
    posunits = options.to.end - @zero
    # negunits = 3 - 1 = 2
    negunits = @zero - options.from.end
    # Adjust the lengths to account for the extension arrows.
    poslength = posunits * @unit
    if options.to.open
      poslength += extensionLength
    neglength = negunits * @unit
    if options.from.open
      neglength += extensionLength
    @start = [@x0 - @asmuth * neglength, @y0 + @attitude * neglength]
    @end = [@x0 + @asmuth * poslength, @y0 - @attitude * poslength]

    # axis line
    @line() if options.drawLine
    # arrows
    @arrow(options.from.end) if options.from.open
    @arrow(options.to.end) if options.to.open
    # ticks & labels
    for n in @ticks(options.from.end, options.to.end, options.step)
      @tick n, options.adjustTick,
        lookup: options.labels
        swap: options.swapLabels
        offset: options.textOffset

  at: (length) =>
    # [x, y] point of length (in units).
    [@x0 + @asmuth * length * @unit, @y0 - @attitude * length * @unit]

  line: =>
    @elements.axis = new Uriel.Path @paper, ['M'] + @start + ['L'] + @end
    @classify @elements.axis, 'axis'
    @elements.geometry.push(@elements.axis)

  arrow: (n) =>
    [x, y] = if n > @zero then @end else @start
    length = (if n > @zero then 1 else -1) * @arrowLength
    path = new Uriel.Path @paper, [
        'M'
        # The point furthest from the start point.
        x + length * @asmuth, y - length * @attitude
        # The points adjacent to the axis.
        # Swap attitude and asmuth because breadth is perpindicular to length.
        x - @arrowBreadth * @attitude, y - @arrowBreadth * @asmuth
        x + @arrowBreadth * @attitude, y + @arrowBreadth * @asmuth
        'z']
    @classify path, 'arrow', n
    @elements.arrows.push(path)
    @elements.geometry.push(path)

  ticks: (from, to, step) =>
    if _.isNumber(step) then (n for n in [from .. to] by step)
    else n for n in [from .. to] when step(n)

  tick: (n, adjust, labelOptions) =>
    # Honor the user tick adjustment.
    [factor, type] = if _.isFunction(adjust)
      result = adjust(n, @tickType)
      result = [1, @tickType] if result is true
      result = [0, false] if result is false
      result
    else [1, @tickType]
    # Get the center of the tick.
    [x, y] = @at n - @zero
    # Get the x/y components of the tick height.
    # Invert attitude and asmuth because ticks are perpindicular to the axis.
    dx = @tickHeight * factor * @attitude
    dy = @tickHeight * factor * @asmuth
    # Get the top and bottom points of the tick.
    top = if type in ['full', 'top']
    then [x - dx, y - dy]
    else [x, y]
    bottom = if type in ['full', 'bottom']
    then [x + dx, y + dy]
    else [x, y]
    unless type == false
      path = new Uriel.Path @paper, ['M'] + top + ['L'] + bottom
      @classify path, 'tick', n
      @elements.ticks.push path
      @elements.geometry.push path
    @label n, top, bottom, labelOptions

  label: (n, top, bottom, options) =>
    return unless options.lookup
    # Pick the point to use.
    point = bottom
    point = top if @tickType == 'top' and not options.swap
    point = top if @tickType != 'top' and options.swap
    # Get the text parts for the label.
    label = if _.isFunction(options.lookup)
      options.lookup(n)
    else if _.has(options.lookup, n)
      options.lookup[n]
    else n
    return unless label? and label != false
    # Find the text offset.
    offset = if _.isFunction(options.offset)
    then options.offset(n)
    else options.offset
    offset *= -1 if point == top
    # Calculate position x and y.
    # Swap attitude and asmuth because labels are offset perpindicular to axis.
    x = point[0] + offset * @attitude
    y = point[1] + offset * @asmuth
    # Create the elements.
    text = new Uriel.Text @paper, x, y, label
    @classify text, 'label', n
    @elements.labels.push text

  classify: (el, type, n=null) =>
    # _.flatten flattens strings into arrays D:
    classes = []
    addClasses = (cls) ->
      if _.isString(cls)
      then classes.push(cls)
      else classes = classes.concat(cls)
    addClasses @classes.all
    addClasses @classes[type]
    addClasses @classes.zero if n == @zero
    addClasses @classes.positive if n > @zero
    addClasses @classes.negative if n < @zero
    el.apply 'class': classes.join(' ')


class Uriel.Group extends Uriel.Element
  constructor: (paper, objects=[], attrs={}) ->
    set = paper.set()
    @elements = []
    super set, attrs
    @add(objects)

  push: (object) =>
    @element.push(object.element)
    @elements.push(object)

  pop: (object) =>
    @element.exclude(object.element)
    _.reject(@elements, ((o) -> o == object))

  add: (objects) =>
    @push(object) for object in objects

  remove: (objects) =>
    @pop(object) for object in objects

  apply: (attrs) =>
    _.map @elements, (elem) -> elem.apply attrs

  animate: (attrs, controls) =>
    _.map @elements, (elem) -> controls.master = elem.animate(attrs, controls)


class Uriel.Animation
  constructor: (@description, @duration=0, @easing='<>', @repeat=false) ->

  run: (callback, delay=null) =>
    controls =
      delay: delay
      callback: callback
      duration: @duration
      easing: @easing
      repeat: @repeat
      master: null
    for [object, attributes] in @description
      console.log 'running', object, attributes
      # object can be null/false in the case of optional objects.
      object.animate(attributes, controls) if object
    if callback and _.isEmpty(@description)
      setTimeout callback, @duration + (delay or 0)


class Uriel.Recipe
  constructor: (@initial, @description, @loop=false, elem=null) ->
    @elem = $(elem)
    @do @initial

  do: (description, callback=null) ->
    if _.isArray(description)
      obj.apply(attrs) for [obj, attrs] in description when obj
      callback() if callback?
    else description.run callback

  trigger: (delay=null) =>
    proceed = @executeFrom 0
    if delay? then setTimeout(proceed, delay) else proceed()

  triggerOnView: (delay=null, options={}) =>
    _.defaults options,
      offset: 'bottom-in-view'
      triggerOnce: true
    @elem.waypoint (=> @trigger(delay)), options

  first: =>
    if _.isNumber @description[0] then 1 else 0

  executeFrom: (i) => (delay=null) =>
    # Given delay replaces delay at [i] if [i] is a number.
    if _.isNumber(@description[i])
      delay ?= @description[i]
      i++
    proceed = =>
      return @reset() if i >= @description.length
      # Assumes that there aren't two numbers in a row.
      @do @description[i], @executeFrom(i + 1)
    if delay? then setTimeout(proceed, delay) else proceed()

  reset: =>
    return unless _.isNumber @loop
    @do @initial
    @trigger @loop


class Uriel.Diagram
  constructor: (@elem, @width=500, @height=300) ->
    @elem = $(elem)
    width = @elem.width()
    @paper = new Raphael elem, width, width * @height / @width
    @paper.setViewBox 0, 0, @width, @height

  register: (object) =>
    @paper.ca[key] = value for key, value of object

  animate: (description, duration=null, easing=null, repeat=null) =>
    new Uriel.Animation(description, duration, easing, repeat)

  recipe: (initial, description, loopAfter=null) =>
    new Uriel.Recipe(initial, description, loopAfter, @elem)

  circle: (x, y, r, attrs={}) =>
    new Uriel.Circle(@paper, x, y, r, attrs)

  path: (description, attrs={}) =>
    new Uriel.Path(@paper, description, attrs)

  axis: (x, y, attrs) =>
    new Uriel.Axis(@paper, x, y, attrs)

  text: (x, y, text, attrs) =>
    new Uriel.Text(@paper, x, y, text, attrs)

  group: (objects, attrs) =>
    new Uriel.Group(@paper, objects, attrs)
