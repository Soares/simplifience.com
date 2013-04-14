# Draw an arc partway around a circle
partialCircle = (cx, cy, r, turns, yaw) ->
  yaw = yaw || 0
  x1 = cx + (r * Math.cos(yaw * τ))
  y1 = cy - (r * Math.sin(yaw * τ))
  x2 = cx + (r * Math.cos((yaw + turns) * τ))
  y2 = cy - (r * Math.sin((yaw + turns) * τ))
  path: ['M', x1, y1, 'A', r, r, 0, +(turns > 0.5), 0, x2, y2]


# Turn and rotate at the same time, not one after the other.
turnRotate = (cx, cy, toplen, botlen, turns) ->
  h = Math.cos(τ * turns)
  v = -Math.sin(τ * turns)
  x1 = cx + toplen * h
  y1 = cy + toplen * v
  x2 = cx - botlen * h
  y2 = cy - botlen * v
  path: ['M', x1, y1, 'L', x2, y2]


# Draws a horizontal line plus half a pixel at the end.
# Corrects a rounding error in the laid line.
horizontal = (x, y, distance) ->
  if distance == 0
  then path: ['M', x, y, 'l', 0.001, 0]
  else path: ['M', x, y, 'l', distance + 0.5, 0]


turnText = (turns) ->
  text: (τ * turns).toFixed(6)


class Unroller extends Uriel.Diagram
  constructor: (elem, width=500, height=200, radius=45, padding=5) ->
    super elem, width, height
    @register
      partialCircle: partialCircle
      turnRotate: turnRotate
      horizontal: horizontal
      turnText: turnText

    middle = height / 2
    zx = padding + radius
    zy = middle + radius

    isDiameterLine = @elem.data('diameter') || false
    stopEarly = @elem.data('pistop') || false
    unit = if isDiameterLine then 2 * radius else radius

    @axis [zx, zy + 0.5],
      unit: unit,
      to: if isDiameterLine then 4 else 8
      capLength: if isDiameterLine then 1/2 else 1

    circle = @circle [zx, zy - radius], radius, class: 'colored'
    outline = @path null, 'stroke-width': 2, class: 'colored line'
    laid = @path null, 'stroke-width': 2, class: 'colored'
    line = @path null, 'stroke-width': 1, class: 'colored'
    counter = if @elem.data('counter')
    then @text [width - 2 * radius, radius], 0.toFixed 6
    else false

    # Length of the inner-circle line beyond the centerpoint.
    toplen = if isDiameterLine then radius else 0
    rollEase = if stopEarly then '<' else '<>'
    rollDuration = if stopEarly then 2500 else 5000
    rollTurns = if stopEarly then 1/2 else 1
    rollDistance = rollTurns * τ * radius

    initial = @animation(
      [circle,
        opacity: 0
        'stroke-width': 2
        transform: '']
      [outline,
        partialCircle: [zx, zy - radius, radius, .9999, -1/4]
        opacity: 0]
      [laid,
        horizontal: [zx, zy, 0]]
      [line,
        opacity: 1
        path: ['M', zx, zy, 'l', unit, 0]]
      [counter,
        turnText: 0
        opacity: 0]
    )

    standUp = @animation(
      [line, transform: ['r', -90, zx, zy]]
    )

    turnRotateShuffle = @animation(
      [line,
        transform: ''
        turnRotate: [zx, zy - radius, radius, toplen, -1/4]]
    )

    fadeIn = @animation(
      [circle, opacity: 1]
      [counter, opacity: 1]
    )

    preRollShuffle = @animation(
      [circle, 'stroke-width': 0]
      [outline, opacity: 1]
      [laid, opacity: 1]
    )

    roll = @animation(
      [circle, transform: ['t', rollDistance, 0]]
      [line, turnRotate: [
        zx + rollDistance
        zy - radius
        radius + 1
        toplen
        -1/4 - rollTurns]]
      [outline, partialCircle: [
        zx + rollDistance
        middle
        radius
        1 - rollTurns
        -1/4]]
      [laid, horizontal: [zx, zy, rollDistance]]
      [counter, turnText: rollTurns]
    )

    fadeOut = @animation(
      [circle, opacity: 0]
      [laid, opacity: 0]
      [line, opacity: 0]
      [outline, opacity: 0]
      [counter, opacity: 0]
    )

    @recipe(initial(), [
      standUp(1000)
      turnRotateShuffle()
      fadeIn(1000)
      preRollShuffle()
      roll(rollDuration, rollEase)
      if stopEarly then 5500 else 3000
      fadeOut(1000, '<')
      initial()
    ], 1000).trigger(3000)


$ -> Uriel.diagram('unroll', Unroller)
