$ -> $('.unroll-pi').each create

create = ->
  width = 500
  height = 200
  paper = util.paperFor(this, width, height)

  radius = 45
  circumference = τ * radius
  middle = height / 2
  padding = 15
  startx = padding + radius
  starty = middle + radius

  # (x, y, length, from, to, steps, orientation, labels, type, dashsize, paper)
  Raphael.g.axis(startx, starty, 8 * radius, 0, 8, 8, null, 0, 't', null, paper)
  circle = paper.circle()
  outline = paper.path().attr('stroke-width', 2)
  laid = paper.path().attr('stroke-width', 2)
  radine = paper.path().attr('stroke-width', 1)
  turns = paper.text(width - 2 * radius, radius, 0.toFixed(6))

  reset = ->
    circle.attr {cx: startx, cy: middle, r: radius, opacity: 0, 'stroke-width': 2}
    outline.attr {circ: [startx, middle, radius, 1, -1/4], opacity: 0}
    laid.attr {path: new util.Path(startx, starty).draw(0.01, 0).string}
    radine.attr {turn: [startx, starty, radius, 0], opacity: 1}
    turns.attr {turns: 0.toFixed(6), opacity: 0}

  begin = ->
    reset()
    radine.animate {turn: [startx, starty, radius, 1/4]}, 1000, '<>', fadeIn

  fadeIn = ->
    radine.attr {turn: [startx, middle, radius, -1/4]}
    a = circle.animate {opacity: 1}, 1000, '<', roll
    turns.animateWith circle, a, {opacity: 1}, 1000, '<', roll

  roll = ->
    circle.attr {'stroke-width': 0}
    outline.attr {opacity: 1}
    laid.attr {opacity: 1}

    a = circle.animate {cx: startx + (Math.PI * radius)}, 2500, '<', -> setTimeout fadeOut, 5500
    radine.animateWith circle, a, {turn: [startx + (Math.PI * radius), middle, radius, -3/4]}, 2500, '<'
    outline.animateWith circle, a, {circ: [startx + (Math.PI * radius), middle, radius, 1/2, -1/4]}, 2500, '<'
    laid.animateWith circle, a, {path: new util.Path(startx, starty).draw(Math.PI * radius, 0).string}, 2500, '<'
    turns.animateWith circle, a, {turns: 1/2}, 2500, '<'

  fadeOut = ->
    a = circle.animate {opacity: 0}, 1000, '<', -> setTimeout begin, 1000
    outline.animateWith circle, a, {opacity: 0}, 1000, '<'
    laid.animateWith circle, a, {opacity: 0}, 1000, '<'
    radine.animateWith circle, a, {opacity: 0}, 1000, '<'
    turns.animateWith circle, a, {opacity: 0}, 1000, '<'

  reset()
  setTimeout begin, 3000
