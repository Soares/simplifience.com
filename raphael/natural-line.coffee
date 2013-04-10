width = 500
height = 50
padding = 50
ticks = 10
numberWidth = width - 3 * padding
numberTick = numberWidth / ticks

oneTick = (paper, x, y) ->
  tick = paper.path("M#{x + 0.5} #{y + 0.5}l0 -4")
  $(tick.node).attr('class', 'axis-line')

arrow = (paper, x, y) ->
  dx = 8
  dy = 2
  ex = x + numberTick
  ey = y + 0.5
  axis = paper.path("M#{x} #{ey}l#{numberTick - dx} 0")
  $(axis.node).attr('class', 'axis-line')
  path = paper.path("M#{ex} #{ey} #{ex - dx} #{ey - dy} #{ex - dx} #{ey + dy}z")
  $(path.node).attr('class', 'axis-arrow')

$ -> $('.natural-line').each ->
  paper = util.paperFor(this, width, height)
  # (x, y, length, from, to, steps, orientation, labels, type, dashsize, paper)
  Raphael.g.axis(padding, height / 2 - 5, numberWidth, 1, ticks, ticks - 1, null, 0, 't', null, paper)
  arrow(paper, padding + numberWidth, height / 2 - 5)
  oneTick(paper, padding, height / 2 - 5)
