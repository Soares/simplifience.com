width = 500
height = 50
padding = 50
numberTick = 35
numberWidth = width - (3 * padding) - numberTick

class NumberLine extends Diagram
  start: =>
    @axis(zx - 0.5, zy, @lineLength, tickCount, capFraction: capFraction)

# arrow = (paper, x, y) ->
#   dx = 8
#   dy = 2
#   ex = x + numberTick
#   ey = y + 0.5
#   axis = paper.path("M#{x} #{ey}l#{numberTick - dx} 0")
#   $(axis.node).attr('class', 'axis-line')
#   path = paper.path("M#{ex} #{ey} #{ex - dx} #{ey - dy} #{ex - dx} #{ey + dy}z")
#   $(path.node).attr('class', 'axis-arrow')

# backArrow = (paper, x, y) ->
#   dx = 8
#   dy = 2
#   sx = x
#   sy = y + 0.5
#   axis = paper.path("M#{x + dx} #{sy}l#{numberTick - dx} 0")
#   $(axis.node).attr('class', 'axis-line')
#   path = paper.path("M#{sx} #{sy} #{sx + dx} #{sy + dy} #{sx + dx} #{sy - dy}z")
#   $(path.node).attr('class', 'axis-arrow')

# zeroTick = (paper, x, y) ->
#   tick = paper.path("M#{x + 0.5} #{y + 0.5}l0 -4")
#   $(tick.node).attr('class', 'axis-line')

# $ -> $('.number-line').each ->
#   paper = util.paperFor(this, width, height)
#   # (x, y, length, from, to, steps, orientation, labels, type, dashsize, paper)
#   Raphael.g.axis(padding + numberTick, height / 2 - 5, numberWidth, -5, 5, 10, null, 0, 't', null, paper)
#   arrow(paper, padding + numberTick + numberWidth, height / 2 - 5)
#   backArrow(paper, padding, height / 2 - 5)
#   zeroTick(paper, padding + numberTick + numberWidth / 2, height / 2 - 5)

$ -> diagram('number-line', NumberLine, width, height)
