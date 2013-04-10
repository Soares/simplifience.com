@τ = 2 * Math.PI;


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
  if _.isArray(attrs?.class)
    node.attr 'class', attrs.class.join(' ')
  else if _.isString(attrs?.class)
    node.attr 'class', attrs.class
  delete attrs.class
  if _.isString(attrs?.style)
    node.attr 'style', attrs.style
  delete attrs.style
  obj.attr attrs


axis = (paper, zx, zy, options) ->
  options = _.defaults options || {},
    arrowBreadth: 1/2           # In terms of options.tickHeight
    arrowClass: 'arrow'
    arrowLength: 2              # In terms of options.tickHeight
    capLength: 1                # In terms of options.unit
    classes: ['axis']           # Added to all elements.
    from: new Bound(0, false)
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

  # Normalize the bounds
  if _.isNumber(options.from)
    options.from = new Bound(options.from)
  if _.isNumber(options.to)
    options.to = new Bound(options.to)

  # Normalize the classes
  if _.isArray(options.classes)
    options.classes = options.classes.join(' ')

  # Normalize the zero tick ratio
  if (_.isBoolean(options.zeroTick) and
      options.zeroTick and
      options.tickType in ['|', '+'])
    options.zeroTick = 1.5

  # Calculate the cap arrow dimensions.
  options.arrowBreadth = options.arrowBreadth * options.tickHeight
  options.arrowLength = options.arrowLength * options.tickHeight

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
  hasPath = options.tickType in ['T', 'L', '+']
  if hasPath
    path = paper.path(['M', sx, sy, 'L', ex, ey])
    $(path.node).attr 'class': "#{options.classes} #{options.lineClass}"

  # Looks up the label for a tick.
  label = (number) ->
    if _.has(options.labels, number)
    then options.labels[number]
    else number

  # Makes a flexible tick.
  tick = (cx, cy, number, zero = false) ->
    full = options.tickType in ['|', '+']
    factor = 1

    # Zero tick gets bigger when ticks cross the axis line.
    if zero and full
      factor = options.zeroTick
    # Zero tick crosses the axs line when other ticks don't.
    else if zero
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

    # Plant the label.
    tickLabel = paper.text textx, texty, label(number)
    $(tickLabel.node).attr class: "#{options.classes} #{options.labelClass}"

    # Make the tick, if they're into that sort of thing.
    if options.tickType != ' '
      tickLine = paper.path ['M', topx, topy, 'L', botx, boty]
      $(tickLine.node).attr class: "#{options.classes} #{options.tickClass}"

  # Make all the ticks.
  for number, position in negticks
    tx = zx - ((position + 1) * options.unit * ux)
    ty = zy + ((position + 1) * options.unit * uy)
    tick(tx, ty, number)
  tick(zx, zy, options.zero, true)
  for number, position in posticks
    tx = zx + ((position + 1) * options.unit * ux)
    ty = zy - ((position + 1) * options.unit * uy)
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

  # Add the cap arrows.
  cap(sx, sy, true) if options.from.open
  cap(ex, ey) if options.to.open


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

  path: (attrs) ->
    applyAttrs(@paper.path(), attrs)

  axis: (zx, zy, options) =>
    axis(@paper, zx, zy, options)


@diagram = (codename, cls, w, h) ->
  $(".#{codename}").each -> new cls(this, w, h).start()
