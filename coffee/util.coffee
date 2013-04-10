@τ = 2 * Math.PI;


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


axisArrow = (paper, x, y, width, right) ->
  if right
    dx = 8
    dy = 2
    ex = x + width
    ey = y + 0.5
    axis = paper.path("M#{x} #{ey}l#{width - dx} 0")
    $(axis.node).attr('class', 'axis-line')
    path = paper.path("M#{ex} #{ey} #{ex - dx} #{ey - dy} #{ex - dx} #{ey + dy}z")
    $(path.node).attr('class', 'axis-arrow')
  else
    dx = 8
    dy = 2
    sx = x
    sy = y + 0.5
    axis = paper.path("M#{x + dx} #{sy}l#{width - dx} 0")
    $(axis.node).attr('class', 'axis-line')
    path = paper.path("M#{sx} #{sy} #{sx + dx} #{sy + dy} #{sx + dx} #{sy - dy}z")
    $(path.node).attr('class', 'axis-arrow')


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

  axis: (startx, starty, tickWidth, tickCount, options) =>
    length = tickWidth * tickCount
    start = options?.start || 0
    end = options?.end || tickCount
    orientation = options?.orientation || 0
    labels = options?.labels || null
    type = options?.type || 't'
    dashsize = options?.dashsize
    starts = options?.starts || true
    ends = options?.ends || false
    capFraction = options?.capFraction || 1
    Raphael.g.axis(
        startx, starty, length, start, end,
        tickCount, orientation, labels, type, dashsize, @paper)
    tick = (x, y) =>
      # TODO: Handle other orientations
      # TODO: Handle dashsize
      @paper.path "M#{x + 0.5} #{y + 0.5}l0 -4"
    endx = if orientation % 2 then startx else startx + length
    endy = if orientation % 2 then starty - length else starty
    if starts
      tick startx, starty
    else
      # TODO: Really handle orientation
      axisArrow(@paper, endx, endy, tickWidth * capFraction, 0)
    if ends
      tick endx, endy
    else
      # TODO: Really handle orientation
      axisArrow(@paper, endx, endy, tickWidth * capFraction, 1)


@diagram = (codename, cls, w, h) ->
  $(".#{codename}").each -> new cls(this, w, h).start()
