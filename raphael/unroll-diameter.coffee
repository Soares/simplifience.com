$ -> $('.unroll-diameter').each create

create = ->
  width = 500
  height = 200
  paper = util.paperFor(this, width, height)
  paper.customAttributes.twirl = (x, y, r, turns) ->
    dx = -r * Math.sin(turns * Math.PI * 2)
    dy = r * Math.cos(turns * Math.PI * 2)
    path: new util.Path(x + dx, y + dy).draw(x - dx, y - dy, true).string

  radius = 45
  diameter = 2 * radius
  circumference = Math.PI * diameter
  middle = height / 2
  padding = 15
  startx = padding + radius
  starty = middle + radius

  # (x, y, length, from, to, steps, orientation, labels, type, dashsize, paper)
  Raphael.g.axis(startx, starty, 8 * radius, 0, 4, 4, 0, false, 't', null, paper)
  circle = paper.circle()
  outline = paper.path().attr('stroke-width', 2)
  laid = paper.path().attr('stroke-width', 2)
  dialine = paper.path().attr('stroke-width', 1)

  reset = ->
    circle.attr {cx: startx, cy: middle, r: radius, opacity: 0, 'stroke-width': 2}
    outline.attr {circ: [startx, middle, radius, 1, -1/4], opacity: 0}
    laid.attr {path: new util.Path(startx, starty).draw(0.01, 0).string}
    dialine.attr {turn: [startx, starty, diameter, 0], opacity: 1}

  begin = ->
    reset()
    dialine.animate {turn: [startx, starty, diameter, .25]}, 1000, '<>', fadeIn

  fadeIn = ->
    dialine.attr {twirl: [startx, middle, radius + 1, 0]}
    circle.animate {opacity: 1}, 1000, '<>', roll

  roll = ->
    circle.attr {'stroke-width': 0}
    outline.attr {opacity: 1}
    laid.attr {opacity: 1}

    a = circle.animate {cx: startx + circumference}, 5000, '<>', -> setTimeout fadeOut, 3000
    outline.animateWith circle, a, {circ: [startx + circumference, middle, radius, 0, -1/4]}, 5000, '<>'
    laid.animateWith circle, a, {path: new util.Path(startx, starty).draw(circumference, 0).string}, 5000, '<>'
    dialine.animateWith circle, a, {twirl: [startx + circumference, middle, radius, 1]}, 5000, '<>'

  fadeOut = ->
    a = circle.animate {opacity: 0}, 1000, '<>', -> setTimeout begin, 1000
    laid.animateWith circle, a, {opacity: 0}, 1000, '<>'
    dialine.animateWith circle, a, {opacity: 0}, 1000, '<>'

  reset()
  setTimeout begin, 3000
