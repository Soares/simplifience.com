// Generated by CoffeeScript 1.4.0
(function() {
  var arrow, height, numberTick, numberWidth, oneTick, padding, ticks, width;

  width = 500;

  height = 50;

  padding = 50;

  ticks = 10;

  numberWidth = width - 3 * padding;

  numberTick = numberWidth / ticks;

  oneTick = function(paper, x, y) {
    var tick;
    tick = paper.path("M" + (x + 0.5) + " " + (y + 0.5) + "l0 -4");
    return $(tick.node).attr('class', 'axis-line');
  };

  arrow = function(paper, x, y) {
    var axis, dx, dy, ex, ey, path;
    dx = 8;
    dy = 2;
    ex = x + numberTick;
    ey = y + 0.5;
    axis = paper.path("M" + x + " " + ey + "l" + (numberTick - dx) + " 0");
    $(axis.node).attr('class', 'axis-line');
    path = paper.path("M" + ex + " " + ey + " " + (ex - dx) + " " + (ey - dy) + " " + (ex - dx) + " " + (ey + dy) + "z");
    return $(path.node).attr('class', 'axis-arrow');
  };

  $(function() {
    return $('.natural-line').each(function() {
      var paper;
      paper = util.paperFor(this, width, height);
      Raphael.g.axis(padding, height / 2 - 5, numberWidth, 1, ticks, ticks - 1, null, 0, 't', null, paper);
      arrow(paper, padding + numberWidth, height / 2 - 5);
      return oneTick(paper, padding, height / 2 - 5);
    });
  });

}).call(this);
