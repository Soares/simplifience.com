width = 500
height = 50
padding = 50
ticks = 10
numberWidth = width - 3 * padding
numberTick = numberWidth / ticks

arrow = (paper, x, y) ->
  dx = 8
  dy = 2
  path = paper.path("M#{x} #{y} #{x - dx} #{y - dy} #{x - dx} #{y + dy}z")
  $(path.node).attr('class', 'axis-arrow')

$ -> $('.natural-ticks').each ->
  paper = util.paperFor(this, width, height)
  # (x, y, length, from, to, steps, orientation, labels, type, dashsize, paper)
  Raphael.g.axis(padding, height / 2 - 5, numberWidth, 1, ticks, ticks - 1, null, 0, '|', null, paper)
  arrow(paper, padding + numberWidth + numberTick, height / 2 - 2.5)
