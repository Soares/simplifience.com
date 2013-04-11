@τ = 2 * Math.PI;

@callbackAfter = (fn, delay) -> () -> setTimeout(fn, delay)


class @Bound
  constructor: (@end, @open = true) ->


class @Path
  constructor: (x, y) ->
    @string = "M #{x} #{y}"

  draw: (x, y, options) =>
    letter = if options?.absolute then 'L' else 'l'
    @string += "#{letter} #{x} #{y}"
    this

  move: (x, y, options) =>
    letter = if options?.absolute then 'M' else 'm'
    @string += "#{letter} #{x} #{y}"
    this

  symmetricArc: (x, y, r, options) =>
    @arc(x, y, r, r, 0, options)
    this

  arc: (x, y, rx, ry, theta, options) =>
    large = +(options?.large || 0)
    invert = +(options?.invert || 0)
    letter = if options?.absolute then 'A' else 'a'
    @string += "#{letter} #{rx} #{ry} #{theta} #{large} #{invert} #{x} #{y}"
    this


partialCircle = (cx, cy, r, turns, yaw) ->
  yaw = yaw || 0
  x1 = cx + (r * Math.cos(yaw * τ))
  y1 = cy - (r * Math.sin(yaw * τ))
  x2 = cx + (r * Math.cos((yaw + turns) * τ))
  y2 = cy - (r * Math.sin((yaw + turns) * τ))
  new Path(x1, y1).symmetricArc x2, y2, r,
    large: turns > 0.5
    absolute: true


rotatedLine = (sx, sy, r, turns) ->
  dx = r * Math.cos(turns * τ)
  dy = -r * Math.sin(turns * τ)
  new Path(sx, sy).draw(dx, dy)


turnRotate = (cx, cy, uplen, downlen, turns) ->
  h = Math.cos(τ * turns)
  v = -Math.sin(τ * turns)
  x1 = cx + uplen * h
  y1 = cy + uplen * v
  x2 = cx - downlen * h
  y2 = cy - downlen * v
  new Path(x1, y1).draw(x2, y2, absolute: true)


applyAttrs = (obj, attrs) ->
  node = $(obj.node)
  attrs ?= {}
  if _.isArray(attrs.class)
    node.attr 'class', attrs.class.join(' ')
  else if _.isString(attrs.class)
    node.attr 'class', attrs.class
  delete attrs.class
  if _.isString(attrs.style)
    node.attr 'style', attrs.style
  delete attrs.style
  if not _.isEmpty(attrs)
    obj.attr attrs
  obj


tspan = (part) ->
  node = document.createElementNS('http://www.w3.org/2000/svg', 'tspan')
  if _.isObject(part)
    node.appendChild(document.createTextNode(part.text))
    delete part.text
    for key, val of part
      node.setAttribute(key, val)
  else
    node.appendChild(document.createTextNode(part))
  node


mathText = (paper, x, y, parts, attrs) ->
  if _.isArray(parts)
    elem = paper.text x, y, ''
    _.each(parts, (part) -> elem.node.appendChild(tspan(part)))
  else
    elem = paper.text x, y, parts
  elem.node.removeAttribute 'style'
  applyAttrs(elem, attrs)


axis = (paper, zx, zy, options) ->
  options = _.defaults options || {},
    arrowBreadth: 1/2           # In terms of options.tickHeight
    arrowClass: 'arrow'
    arrowLength: 2              # In terms of options.tickHeight
    capLength: 1                # In terms of options.unit
    classes: ['axis']           # Added to all elements.
    doTick: true
    from: null                  # From options.zero.
    labelClass: ''              # Inferred from text.axis
    labels: {}                  # Missing labels will use the tick number.
    lineClass: ''               # path.axis:not(.arrow):not(.tick) preferred.
    step: 1
    swapLabels: false           # Put labels opposite ticks.
    textOffset: 7               # From end of tick to middle of text.
    tickClass: 'tick'
    tickHeight: 4               # In pixels.
    tickType: 'T'  # one of T L | + or space
    to: new Bound(10, true)
    turns: 0  # [0, 1) in turns
    unit: 10                    # In pixels.
    zero: 0                     # Number to start at.
    # For type L and T zeroTick is a bool which makes the zero tick cross the
    # axis. For type + and | it's a factor by which the zero tick is larger.
    zeroTick: true              # In terms of ticks (if it's a number).
    zeroLabel: true             # Whether to label zero.

  geometry = paper.set()
  labels = paper.set()

  # Set from to zero if it's unset.
  options.zero = +(options.zero)
  options.from = new Bound(options.zero, false) unless options.from?

  # Normalize the bounds
  if _.isNumber(options.from)
    options.from = new Bound(options.from)
  if _.isNumber(options.to)
    options.to = new Bound(options.to)

  # Normalize the classes
  if _.isArray(options.classes)
    options.classes = options.classes.join(' ')

  # Normalize the zero tick ratio
  if _.isBoolean(options.zeroTick) and options.tickType in ['|', '+']
    options.zeroTick = if options.zeroTick then 1.5 else 1

  # Calculate the cap arrow dimensions.
  options.arrowBreadth = options.arrowBreadth * options.tickHeight
  options.arrowLength = options.arrowLength * options.tickHeight
  stepWidth = options.unit * options.step

  # Determine what ticks to draw on each side of zero.
  # 1 2 |3| 4 5 6 7
  # posunits = 7 - 3 = 4
  posunits = options.to.end - options.zero
  posticks = (n for n in [options.zero .. options.to.end] by options.step)[1...]
  poslength = posunits * options.unit
  if options.to.open
    poslength += options.capLength * options.unit - options.arrowLength
  # negunits = 3 - 1 = 2
  negunits = options.zero - options.from.end
  negticks = (n for n in [options.from.end ... options.zero] by options.step)
  neglength = negunits * options.unit
  if options.from.open
    neglength += options.capLength * options.unit - options.arrowLength
  turns = τ * options.turns

  # Calculate the global values.
  length = neglength + poslength
  ux = Math.cos(turns)
  uy = Math.sin(turns)
  # start point.
  sx = zx - (neglength * ux)
  sy = zy + (neglength * uy)
  # end point
  ex = zx + (poslength * ux)
  ey = zy - (poslength * uy)

  # Add the axis line.
  hasPath = options.tickType in ['T', 'L', '+', false]
  if hasPath
    path = paper.path(['M', sx, sy, 'L', ex, ey])
    $(path.node).attr 'class': "#{options.classes} #{options.lineClass}"
    geometry.push(path)

  # Looks up the label for a tick.
  label = (tx, ty, number) ->
    if options.labels == false
      return
    labelParts = if _.isFunction(options.labels)
      options.labels(number)
    else if _.has(options.labels, number)
      options.labels[number]
    else
      number
    if not labelParts?
      return
    elemAttrs = class: "#{options.classes} #{options.labelClass}"
    elem = mathText(paper, tx, ty, labelParts, elemAttrs)
    labels.push(elem)


  # Makes a flexible tick.
  tick = (cx, cy, number, zero = false) ->
    # TODO: these are hacky.
    if zero and options.zeroTick == 0
      return
    if _.isFunction(options.doTick) and not options.doTick(number)
      return

    if options.tickType == ' '
      textx = cx + options.textOffset * uy
      texty = cy + options.textOffset * ux
      label(textx, texty, number) unless zero and not options.zeroLabel
      return

    if options.tickType == false
      return

    full = options.tickType in ['|', '+']
    factor = 1

    # Zero tick gets bigger when ticks cross the axis line.
    if zero and full
      factor = options.zeroTick
    # Zero tick crosses the axs line when other ticks don't.
    else if zero and options.zeroTick
      full = true
      factor = 2

    # Figure out how much of the tickHeight goes above/below.
    if full
      top = factor * 1/2
      bottom = factor * 1/2
    else if options.tickType == 'L'
      top = factor
      bottom = 0
    else
      top = 0
      bottom = factor

    # We swap ux and uy because ticks are perpindicular to the axis.
    topx = cx - (options.tickHeight * top * uy)
    topy = cy - (options.tickHeight * top * ux)
    botx = cx + (options.tickHeight * bottom * uy)
    boty = cy + (options.tickHeight * bottom * ux)

    # Figure out where the text goes.
    toff = options.tickHeight + options.textOffset
    if options.swapLabels
      toff *= -1
    textx = cx + (toff * uy)
    texty = cy + (toff * ux)

    label(textx, texty, number) unless zero and not options.zeroLabel
    tickLine = paper.path ['M', topx, topy, 'L', botx, boty]
    $(tickLine.node).attr class: "#{options.classes} #{options.tickClass}"
    geometry.push(tickLine)

  # Make all the ticks.
  for number, position in negticks
    tx = zx - ((negticks.length - position) * stepWidth * ux)
    ty = zy + ((negticks.length - position) * stepWidth * uy)
    tick(tx, ty, number)
  tick(zx, zy, options.zero, true)
  for number, position in posticks
    tx = zx + ((position + 1) * stepWidth * ux)
    ty = zy - ((position + 1) * stepWidth * uy)
    tick(tx, ty, number)

  # Makes cap arrows.
  cap = (cx, cy, invert = false) ->
    dl = if invert then -options.arrowLength else options.arrowLength
    db = options.arrowBreadth
    arrow = paper.path [
        'M'
        # The point furthest from the axis.
        cx + dl * ux, cy - dl * uy
        # The points adjacent to the axis.
        # We swap ux and uy because arrow breadth is perpindicular to the axis.
        cx - db * uy, cy - db * ux
        cx + db * uy, cy + db * ux
        'z']
    $(arrow.node).attr class: "#{options.classes} #{options.arrowClass}"
    geometry.push(arrow)

  # Add the cap arrows.
  cap(sx, sy, true) if options.from.open
  cap(ex, ey) if options.to.open
  [geometry, labels]


class @Diagram
  constructor: (@elem, width, height) ->
    @elem = $(elem)
    trueWidth = @elem.width()
    aspect = height / width
    @paper = new Raphael elem, trueWidth, trueWidth * aspect
    @paper.customAttributes.partialCircle = (x, y, r, turns, yaw) ->
      # path: partialCircle(x, y, r, turns, yaw).string
      path = partialCircle(x, y, r, turns, yaw)
      path: path.string
    @paper.customAttributes.turnRotate = (x, y, uplen, downlen, turns) ->
      path: turnRotate(x, y, uplen, downlen, turns).string
    @paper.customAttributes.turnText = (turns) ->
      text: (τ * turns).toFixed(6)
    @paper.setViewBox 0, 0, width, height

  circle: (attrs) ->
    applyAttrs(@paper.circle(), attrs)

  path: (attrs) ->
    applyAttrs(@paper.path(), attrs)

  axis: (zx, zy, options) =>
    axis(@paper, zx, zy, options)

  text: (x, y, parts, attrs) =>
    mathText(@paper, x, y, parts, attrs)


@diagram = (codename, cls, w, h) ->
  $(".#{codename}").each -> new cls(this, w, h).start()




# Building Flexible Axes

class @Tick
  constructor: (@paper, @x, @y, @turns, @height, @full) ->
    # @turns is the rotation *of the axis*, not of the tick.
    # The tick will be perpindicular to the @turns.
    # If the tick is @full then a turn of 1/4 is the same as a turn of -1/4.
    # Otherwise the turn determines which half is ticked.

  larger: (scale) =>
    if @full then @height *= scale else @full = true

  path: =>
    u = Math.cos τ * @turns
    v = Math.sin τ * @turns
    if @full
      # Invert v and u because ticks are perpindicular
      topx = @x - @height * v
      topy = @y + @height * u
    else
      topx = @x
      topy = @y
    botx = @x + @height * v
    boty = @y + @height * u
    @paper.path ['M', topx, topy, 'L', botx, boty]




class @Axis
  constructor: (@paper, @x0, @y0, options={}) ->
    options = _.defaults options,
      # Function to adjust specific ticks. tickType is one of 'top', 'bottom',
      # or 'full'.  The function should return [factor, type] where factor is
      # a scaling factor type is 'top', 'bottom', or 'full'.
      adjustTick: ((num, type) ->
        if num == options.zero
          if type == 'full' then [1.5, 'full'] else [1, 'full']
        else [1, type])
      arrowDimensions: [1, 1/2]  # [length (in unit), breadth (in tickHeight)]
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
      to: new Bound(10, true)  # Go to 10 (open bound) by default.
      turns: 0 # Rotation in turns. 0 is left-to-right, 1/4 is bottom-up, etc.
      unit: 10                    # In pixels.
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
      geometry: paper.set()  # axis, ticks, and arrows
      ticks: paper.set()
      arrows: paper.set()
      labels: paper.set()

    # Copy global options into this.
    @unit = options.unit
    @zero = options.zero
    @tickHeight = options.tickHeight
    @tickType = options.tickType

    # Normalize the bounds.
    # Start at options.zero if they did't give another start point.
    options.from ?= new Bound(@zero, false)
    # Make sure the bounds are bounds objects.
    if _.isNumber(options.from)
      options.from = new Bound(options.from)
    if _.isNumber(options.to)
      options.to = new Bound(options.to)

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
    extensionLength = capLength * @unit - @arrowLength
    # Determine how many units are on each side of zero.
    # 1 2 |3| 4 5 6 7
    # posunits = 7 - 3 = 4
    posunits = to.end - @zero
    # negunits = 3 - 1 = 2
    negunits = @zero - from.end
    # Determine the length of the axis.
    poslength = posunits * @unit
    if to.open
      poslength += extensionLength
    neglength = negunits * @unit
    if from.open
      negLength += extensionLength
    # start point of line.
    @start = @point neglength
    @end = @point poslength

    # axis line
    @line if options.drawLine
    # arrows
    @arrow(options.from.end) if options.from.open
    @arrow(options.to.end) if options.to.open
    # ticks & labels
    for n in @ticks(options.from.end, options.to.end, options.step)
      @tick n, options.adjustTick,
        lookup: options.labels
        swap: options.swapLabels
        offset: options.textOffset

  point: (length) =>
    # [x, y] point of length (in units).
    [@x0 + @asmuth * length * @unit, @y0 - @attitude * length * @unit]

  line: =>
    @elements.axis = paper.path ['M'] + @start + ['L'] + @end
    @classify @elements.axis, 'axis'
    @elements.geometry.push(@elements.axis)

  arrow: (n) =>
    [x, y] = if n > @zero then @end else @start
    length = (if n > @zero then 1 else -1) * @arrowLength
    path = paper.path [
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
    if @tickType == false
      return
    # Honor the user tick adjustment.
    [factor, type] = if _.isFunction(adjust)
    then adjust(n, @tickType)
    else [1, @tickType]
    # Get the center of the tick.
    [x, y] = @point(n - @zero)
    # Get the x/y components of the tick height.
    # Invert attitude and asmuth because ticks are perpindicular to the axis.
    dx = @tickHeight * factor * @attitude
    dy = @tickHeight * factor * @asmuth
    # Get the top and bottom points of the tick.
    top = if type in ['full', 'top']
    then [x - dx, y + dy]
    else [x, y]
    bottom = if type in ['full', 'bottom']
    then [x + dx, y - dy]
    else [x, y]
    path = @paper.path ['M'] + top + ['L'] + bottom
    @classify path, 'tick', n
    @elements.ticks.push path
    @elements.geometry.push path
    tip = if labelOptions.swap then top else bottom
    @label n, tip, labelOptions.lookup, labelOptions.offset

  label: (n, point, lookup, getOffset) =>
    if lookup == false
      return
    label = if _.isFunction(lookup)
      lookup(label)
    else if _.has(lookup, n)
      lookup[n]
    else n
    if not label?
      return
    offset = if _.isFunction(getOffset) then getOffset(n) else getOffset
    # Swap attitude and asmuth because labels are offset perpindicualr to axis.
    x = point[0] + offset * @attitude
    y = point[1] + offset * @asmuth
    text = Text(@paper, x, y, label)
    @classify text, 'label', n
    @elements.labels.push text

  classify: (el, type, n=null) =>
    extra = []
    extra.push('zero') if n == @zero
    extra.push('negative') if n < @zero
    extra.push('positive') if n > @zero
    classes = _.flatten(@classes.all, @classes[type], extra)
    el.node.setAttribute 'class', classes.join(' ')



axis = (paper, zx, zy, options) ->
  options = _.defaults options || {},
    arrowBreadth: 1/2           # In terms of options.tickHeight
    arrowClass: 'arrow'
    arrowLength: 2              # In terms of options.tickHeight
    capLength: 1                # In terms of options.unit
    classes: ['axis']           # Added to all elements.
    doTick: true
    from: null                  # From options.zero.
    labelClass: ''              # Inferred from text.axis
    labels: {}                  # Missing labels will use the tick number.
    lineClass: ''               # path.axis:not(.arrow):not(.tick) preferred.
    step: 1
    swapLabels: false           # Put labels opposite ticks.
    textOffset: 7               # From end of tick to middle of text.
    tickClass: 'tick'
    tickHeight: 4               # In pixels.
    tickType: 'T'  # one of T L | + or space
    to: new Bound(10, true)
    turns: 0  # [0, 1) in turns
    unit: 10                    # In pixels.
    zero: 0                     # Number to start at.
    # For type L and T zeroTick is a bool which makes the zero tick cross the
    # axis. For type + and | it's a factor by which the zero tick is larger.
    zeroTick: true              # In terms of ticks (if it's a number).
    zeroLabel: true             # Whether to label zero.

  geometry = paper.set()
  labels = paper.set()

  # Set from to zero if it's unset.
  options.zero = +(options.zero)
  options.from = new Bound(options.zero, false) unless options.from?

  # Normalize the bounds
  if _.isNumber(options.from)
    options.from = new Bound(options.from)
  if _.isNumber(options.to)
    options.to = new Bound(options.to)

  # Normalize the classes
  if _.isArray(options.classes)
    options.classes = options.classes.join(' ')

  # Normalize the zero tick ratio
  if _.isBoolean(options.zeroTick) and options.tickType in ['|', '+']
    options.zeroTick = if options.zeroTick then 1.5 else 1

  # Calculate the cap arrow dimensions.
  options.arrowBreadth = options.arrowBreadth * options.tickHeight
  options.arrowLength = options.arrowLength * options.tickHeight
  stepWidth = options.unit * options.step

  # Determine what ticks to draw on each side of zero.
  # 1 2 |3| 4 5 6 7
  # posunits = 7 - 3 = 4
  posunits = options.to.end - options.zero
  posticks = (n for n in [options.zero .. options.to.end] by options.step)[1...]
  poslength = posunits * options.unit
  if options.to.open
    poslength += options.capLength * options.unit - options.arrowLength
  # negunits = 3 - 1 = 2
  negunits = options.zero - options.from.end
  negticks = (n for n in [options.from.end ... options.zero] by options.step)
  neglength = negunits * options.unit
  if options.from.open
    neglength += options.capLength * options.unit - options.arrowLength
  turns = τ * options.turns

  # Calculate the global values.
  length = neglength + poslength
  ux = Math.cos(turns)
  uy = Math.sin(turns)
  # start point.
  sx = zx - (neglength * ux)
  sy = zy + (neglength * uy)
  # end point
  ex = zx + (poslength * ux)
  ey = zy - (poslength * uy)

  # Add the axis line.
  hasPath = options.tickType in ['T', 'L', '+', false]
  if hasPath
    path = paper.path(['M', sx, sy, 'L', ex, ey])
    $(path.node).attr 'class': "#{options.classes} #{options.lineClass}"
    geometry.push(path)

  # Looks up the label for a tick.
  label = (tx, ty, number) ->
    if options.labels == false
      return
    labelParts = if _.isFunction(options.labels)
      options.labels(number)
    else if _.has(options.labels, number)
      options.labels[number]
    else
      number
    if not labelParts?
      return
    elemAttrs = class: "#{options.classes} #{options.labelClass}"
    elem = mathText(paper, tx, ty, labelParts, elemAttrs)
    labels.push(elem)


  # Makes a flexible tick.
  tick = (cx, cy, number, zero = false) ->
    # TODO: these are hacky.
    if zero and options.zeroTick == 0
      return
    if _.isFunction(options.doTick) and not options.doTick(number)
      return

    if options.tickType == ' '
      textx = cx + options.textOffset * uy
      texty = cy + options.textOffset * ux
      label(textx, texty, number) unless zero and not options.zeroLabel
      return

    if options.tickType == false
      return

    full = options.tickType in ['|', '+']
    factor = 1

    # Zero tick gets bigger when ticks cross the axis line.
    if zero and full
      factor = options.zeroTick
    # Zero tick crosses the axs line when other ticks don't.
    else if zero and options.zeroTick
      full = true
      factor = 2

    # Figure out how much of the tickHeight goes above/below.
    if full
      top = factor * 1/2
      bottom = factor * 1/2
    else if options.tickType == 'L'
      top = factor
      bottom = 0
    else
      top = 0
      bottom = factor

    # We swap ux and uy because ticks are perpindicular to the axis.
    topx = cx - (options.tickHeight * top * uy)
    topy = cy - (options.tickHeight * top * ux)
    botx = cx + (options.tickHeight * bottom * uy)
    boty = cy + (options.tickHeight * bottom * ux)

    # Figure out where the text goes.
    toff = options.tickHeight + options.textOffset
    if options.swapLabels
      toff *= -1
    textx = cx + (toff * uy)
    texty = cy + (toff * ux)

    label(textx, texty, number) unless zero and not options.zeroLabel
    tickLine = paper.path ['M', topx, topy, 'L', botx, boty]
    $(tickLine.node).attr class: "#{options.classes} #{options.tickClass}"
    geometry.push(tickLine)

  # Make all the ticks.
  for number, position in negticks
    tx = zx - ((negticks.length - position) * stepWidth * ux)
    ty = zy + ((negticks.length - position) * stepWidth * uy)
    tick(tx, ty, number)
  tick(zx, zy, options.zero, true)
  for number, position in posticks
    tx = zx + ((position + 1) * stepWidth * ux)
    ty = zy - ((position + 1) * stepWidth * uy)
    tick(tx, ty, number)

  # Makes cap arrows.
  cap = (cx, cy, invert = false) ->
    length = if invert then -options.arrowLength else options.arrowLength
    arrow = capArrow(paper, cx, cy, options.turns, length, options.arrowBreadth)
    $(arrow.node).attr class: "#{options.classes} #{options.arrowClass}"
    geometry.push(arrow)

  # Add the cap arrows.
  cap(sx, sy, true) if options.from.open
  cap(ex, ey) if options.to.open
  [geometry, labels]



# Makes cap arrows.
# Give negative length to invert.
capArrow = (paper, x, y, turns, length, breadth) ->
  u = Math.cos(τ * turns)
  v = Math.sin(τ * turns)
  paper.path [
      'M'
      # The point furthest from the start point.
      x + length * u, y - length * v
      # The points adjacent to the axis.
      # We swap u and v because arrow breadth is perpindicular to the length.
      x - breadth * v, y - breadth * u
      x + breadth * v, y + breadth * u
      'z']
