// Generated by CoffeeScript 1.4.0
(function() {
  var arrow, height, numberTick, numberWidth, padding, ticks, width;

  width = 500;

  height = 50;

  padding = 50;

  ticks = 10;

  numberWidth = width - 3 * padding;

  numberTick = numberWidth / ticks;

  arrow = function(paper, x, y) {
    var dx, dy, path;
    dx = 8;
    dy = 2;
    path = paper.path("M" + x + " " + y + " " + (x - dx) + " " + (y - dy) + " " + (x - dx) + " " + (y + dy) + "z");
    return $(path.node).attr('class', 'axis-arrow');
  };

  $(function() {
    return $('.natural-ticks').each(function() {
      var paper;
      paper = util.paperFor(this, width, height);
      Raphael.g.axis(padding, height / 2 - 5, numberWidth, 1, ticks, ticks - 1, null, 0, '|', null, paper);
      return arrow(paper, padding + numberWidth + numberTick, height / 2 - 2.5);
    });
  });

}).call(this);
