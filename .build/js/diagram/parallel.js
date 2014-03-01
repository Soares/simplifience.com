// Generated by CoffeeScript 1.7.1
(function() {
  var BentLines, ParallelLines,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  ParallelLines = (function(_super) {
    __extends(ParallelLines, _super);

    function ParallelLines(elem, width, height) {
      var p;
      if (width == null) {
        width = 500;
      }
      if (height == null) {
        height = 50;
      }
      ParallelLines.__super__.constructor.call(this, elem, width, height);
      p = this.paper.path(['M', 0, 16, 'l', 500, 0]);
      p.node.setAttribute('class', 'colored');
      p = this.paper.path(['M', 0, 33, 'l', 500, 0]);
      p.node.setAttribute('class', 'colored');
    }

    return ParallelLines;

  })(Uriel.Diagram);

  BentLines = (function(_super) {
    __extends(BentLines, _super);

    function BentLines(elem, width, height) {
      var p;
      if (width == null) {
        width = 500;
      }
      if (height == null) {
        height = 75;
      }
      BentLines.__super__.constructor.call(this, elem, width, height);
      p = this.paper.path(['M', 0, 16, 'a', 600, 100, 0, 0, 1, 600, 100]);
      p.node.setAttribute('class', 'colored line');
      p = this.paper.path(['M', 0, 33, 'l', 500, 0]);
      p.node.setAttribute('class', 'colored');
    }

    return BentLines;

  })(Uriel.Diagram);

  $(function() {
    Uriel.diagram('parallel', ParallelLines);
    return Uriel.diagram('bent', BentLines);
  });

}).call(this);
