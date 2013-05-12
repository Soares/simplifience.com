WIDTH = 500
HEIGHT = 500
UNIT = 50

class AxeRadar extends Uriel.Diagram
  constructor: (elem) ->
    super elem, WIDTH, HEIGHT
    @guide UNIT
    @guide UNIT * 2
    @guide UNIT * 3
    @guide UNIT * 4
    @line 0
    @line 1/16
    @line 2/16
    @line 3/16
    @line 4/16
    @line 5/16
    @line 6/16
    @line 7/16

    [x, y] = @elem.data('axe') || [1.9, 1]
    turns = @elem.data('angle') || 1/6
    unless @elem.data('off')
      @dot 'The Axe', x, y, 12, 'blue'
    u = Math.cos τ * turns
    v = Math.sin τ * turns
    spread = (@elem.data('spread') || 1) * (36 / 50)
    dx = u * spread
    dy = v * -spread
    [cx, cy] = @elem.data('center') || [x, y]
    @dot 'The Blade', cx + dx, cy - dy, 8, 'red'
    @dot 'The Handle', cx - dx, cy + dy, 8, 'red'


  dot: (label, x, y, radius, color) =>
    x = x * UNIT + (WIDTH / 2)
    y = -y * UNIT + (HEIGHT / 2)
    inner = @paper.circle(x, y, radius - 2)
    outer = @paper.circle(x, y, radius)
    inner.node.setAttribute 'class', color
    outer.node.setAttribute 'class', color + ' line'
    text = @paper.text(x + 42, y, label)
    text.node.setAttribute 'class', color

  guide: (radius) =>
    guide = @paper.circle WIDTH / 2, HEIGHT / 2, radius
    guide.node.setAttribute 'class', 'guide'

  line: (turns) =>
    u = Math.cos(turns * τ)
    v = Math.sin(turns * τ)
    cx = WIDTH / 2
    cy = HEIGHT / 2
    dx = 200
    dy = 200
    line = @paper.path(['M', cx + u * dx, cy - v * dy, 'L', cx - u * dx, cy + v * dy])
    line.node.setAttribute 'class', 'guide'

$ -> Uriel.diagram('axe', AxeRadar)
