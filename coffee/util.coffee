@τ = 2 * Math.PI;
@util = {}


class @util.Path
  constructor: (x, y) ->
    @string = "M #{x} #{y}"

  draw: (x, y, absolute) =>
    letter = if absolute then 'L' else 'l'
    @string += "#{letter} #{x} #{y}"
    this

  move: (x, y, absolute) =>
    letter = if absolute then 'M' else 'm'
    @string += "#{letter} #{x} #{y}"
    this

  arc: (x, y, rx, ry, theta, large, invert, absolute) =>
    large = +(large || 0)
    invert = +(invert || 0)
    letter = if absolute then 'A' else 'a'
    @string += "#{letter} #{rx} #{ry} #{theta} #{large} #{invert} #{x} #{y}"
    this


@util.partialCircle = (cx, cy, r, turns, yaw) ->
  yaw = yaw || 0
  x1 = cx + (r * Math.cos(yaw * τ))
  y1 = cy - (r * Math.sin(yaw * τ))
  x2 = cx + (r * Math.cos((yaw + turns) * τ))
  y2 = cy - (r * Math.sin((yaw + turns) * τ))
  new util.Path(x1, y1).arc(x2, y2, r, r, 0, turns > 0.5, false, true).string


@util.rotatedLine = (sx, sy, r, turns) ->
  dx = r * Math.cos(turns * τ)
  dy = -r * Math.sin(turns * τ)
  new util.Path(sx, sy).draw(dx, dy).string


@util.paperFor = (elem, width, height) ->
  w = $(elem).width()
  paper = new Raphael elem, w, w * height / width
  paper.customAttributes.circ = (x, y, r, turns, yaw) ->
    path: util.partialCircle(x, y, r, turns, yaw)
  paper.customAttributes.turn = (x, y, r, turns) ->
    path: util.rotatedLine(x, y, r, turns)
  paper.customAttributes.turns = (turns) ->
    text: (τ * turns).toFixed(6)
  paper.setViewBox 0, 0, width, height
  paper
