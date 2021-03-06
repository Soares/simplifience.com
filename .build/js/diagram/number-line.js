// Generated by CoffeeScript 1.7.1
(function() {
  var ComplexPlane, LARGE, NumberLine, NumberPlane, OnePlane, PADDING, PolarPlane, SMALL, UNIT,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  LARGE = 500;

  SMALL = 50;

  PADDING = 40;

  UNIT = 35;

  NumberLine = (function(_super) {
    __extends(NumberLine, _super);

    function NumberLine(elem, width, height) {
      var numberOnly, positives, x, y;
      if (width == null) {
        width = LARGE;
      }
      if (height == null) {
        height = SMALL;
      }
      NumberLine.__super__.constructor.call(this, elem, width, height);
      numberOnly = this.elem.data('only-numbers') || false;
      positives = this.elem.data('positives') || false;
      x = positives ? PADDING + UNIT : width / 2;
      y = height / 2;
      this.axis([x, y], {
        unit: UNIT,
        tickType: numberOnly ? false : null,
        drawLine: !numberOnly,
        textOffset: numberOnly ? 2 : null,
        from: positives ? null : -5,
        to: positives ? 10 : 5,
        zero: positives ? 1 : 0
      });
    }

    return NumberLine;

  })(Uriel.Diagram);

  NumberPlane = (function(_super) {
    __extends(NumberPlane, _super);

    function NumberPlane(elem, width, height) {
      var expand, imaginary, initial, real, zero, zx, zy, _ref;
      if (width == null) {
        width = LARGE;
      }
      if (height == null) {
        height = LARGE;
      }
      NumberPlane.__super__.constructor.call(this, elem, width, height);
      _ref = [width / 2, height / 2], zx = _ref[0], zy = _ref[1];
      zero = this.text([zx, zy + 12], '0');
      real = this.axis([zx, zy], {
        unit: UNIT,
        from: -5,
        to: 5,
        labels: function(num) {
          if (num === 0) {
            return false;
          } else {
            return num;
          }
        }
      });
      imaginary = this.axis([zx, zy], {
        unit: UNIT,
        from: -5,
        to: 5,
        tickType: 'top',
        adjustTick: function(num) {
          return num !== 0;
        },
        labels: function(num) {
          if (num === 0) {
            return false;
          } else {
            return '?';
          }
        }
      });
      initial = this.animation([
        imaginary.elements.geometry, {
          transform: '',
          opacity: 1
        }
      ], [
        imaginary.elements.labels, {
          transform: '',
          opacity: 0
        }
      ], [
        zero, {
          transform: ''
        }
      ]);
      expand = this.animation([
        zero, {
          transform: ['t', -8, 0]
        }
      ], [
        imaginary.elements.geometry, {
          transform: ['r', -90, zx, zy]
        }
      ], [
        imaginary.elements.labels, {
          transform: ['r', -90, zx, zy, 'r', 90, 't', 0],
          opacity: 1
        }
      ]);
      this.recipe(initial(), [expand(1500, '<'), 5000, initial(750, '>')], 8000).triggerOnView();
    }

    return NumberPlane;

  })(Uriel.Diagram);

  ComplexPlane = (function(_super) {
    __extends(ComplexPlane, _super);

    function ComplexPlane(elem) {
      this.makeVerticalAxis = __bind(this.makeVerticalAxis, this);
      this.labelZero = __bind(this.labelZero, this);
      this.setup = __bind(this.setup, this);
      ComplexPlane.__super__.constructor.call(this, elem, {
        unit: UNIT
      });
    }

    ComplexPlane.prototype.setup = function() {
      this.rule([2, 3], [0, 3]);
      this.rule([2, 3], [2, 0]);
      this.text([2.6, 3.2], [
        '2 + 3', {
          text: 'i',
          'font-style': 'italic'
        }
      ]);
      return this.point([2, 3], 'red');
    };

    ComplexPlane.prototype.labelZero = function() {
      return this.text([-0.33, -0.4], 0);
    };

    ComplexPlane.prototype.makeVerticalAxis = function() {
      return ComplexPlane.__super__.makeVerticalAxis.call(this, {
        textOffset: 10,
        labels: function(num) {
          if (num === 0) {
            return false;
          } else {
            return [
              num, {
                text: 'i',
                'font-style': 'italic'
              }
            ];
          }
        }
      });
    };

    return ComplexPlane;

  })(Uriel.Plane);

  PolarPlane = (function(_super) {
    __extends(PolarPlane, _super);

    function PolarPlane(elem) {
      this.setup = __bind(this.setup, this);
      this.drawGuides = __bind(this.drawGuides, this);
      this.makeVerticalAxis = __bind(this.makeVerticalAxis, this);
      this.makeHorizontalAxis = __bind(this.makeHorizontalAxis, this);
      PolarPlane.__super__.constructor.call(this, elem, {
        unit: UNIT / 2
      });
    }

    PolarPlane.prototype.makeHorizontalAxis = function() {
      return PolarPlane.__super__.makeHorizontalAxis.call(this, {
        from: -10,
        to: 10,
        step: 2
      });
    };

    PolarPlane.prototype.makeVerticalAxis = function() {
      return PolarPlane.__super__.makeVerticalAxis.call(this, {
        from: -10,
        to: 10,
        step: 2,
        textOffset: 10,
        labels: function(num) {
          if (num === 0) {
            return false;
          } else {
            return [
              num, {
                text: 'i',
                'font-style': 'italic'
              }
            ];
          }
        }
      });
    };

    PolarPlane.prototype.drawGuides = function() {
      this.guide(2);
      this.guide(4);
      this.guide(6);
      this.guide(8);
      return this.guide(10);
    };

    PolarPlane.prototype.setup = function() {
      var answer, drop, engage, fadeIn, initial, result, rotate, scale;
      this.point([3, 0], 'red');
      this.point([0, 2], 'blue');
      result = this.point([3, 0], 'violet');
      initial = this.animation(result.moveTo([3, 0]), [
        result, {
          transform: '',
          opacity: 0
        }
      ]);
      engage = this.animation((function() {
        return $('.tick.zero').addClass('active');
      }));
      fadeIn = this.animation((function() {
        $('.tick').removeClass('active');
        return $('.tick.one').addClass('active');
      }), [
        result, {
          opacity: 1
        }
      ]);
      scale = this.animation(result.moveTo([6, 0]));
      rotate = this.animation([
        result, {
          transform: "R-90 " + this.origin,
          delay: 1 / 2
        }
      ], (function() {
        $('.tick').removeClass('active');
        return $('.tick.two').addClass('active');
      }));
      answer = this.animation([
        result, {
          transform: ''
        }
      ], result.moveTo([0, 6]), (function() {
        $('.tick').removeClass('active');
        return $('.tick.three').addClass('active');
      }));
      drop = this.animation(result.moveTo([0, 0]), [
        result, {
          opacity: 0
        }
      ], (function() {
        return $('.tick').removeClass('active');
      }));
      return this.recipe(initial(), [500, engage(), 2500, fadeIn(500), scale(1000, '<'), 1000, rotate(1000, '<'), 1000, answer(), 4000, drop(750, 'backOut')], 2000).triggerOnView();
    };

    return PolarPlane;

  })(Uriel.Plane);

  OnePlane = (function(_super) {
    __extends(OnePlane, _super);

    function OnePlane(elem) {
      this.setup = __bind(this.setup, this);
      this.drawGuides = __bind(this.drawGuides, this);
      this.makeVerticalAxis = __bind(this.makeVerticalAxis, this);
      this.makeHorizontalAxis = __bind(this.makeHorizontalAxis, this);
      OnePlane.__super__.constructor.call(this, elem, {
        unit: UNIT * 1.5
      });
    }

    OnePlane.prototype.makeHorizontalAxis = function() {
      return OnePlane.__super__.makeHorizontalAxis.call(this, {
        from: -3,
        to: 3,
        labels: function(num) {
          if (num > 1) {
            return num;
          } else {
            return false;
          }
        },
        adjustTick: function(num) {
          if (num > 1) {
            return true;
          } else {
            return false;
          }
        }
      });
    };

    OnePlane.prototype.makeVerticalAxis = function() {
      return OnePlane.__super__.makeVerticalAxis.call(this, {
        from: -3,
        to: 3,
        labels: false,
        tickType: false
      });
    };

    OnePlane.prototype.drawGuides = function() {
      this.guide(2).element.toBack();
      return this.guide(3).element.toBack();
    };

    OnePlane.prototype.setup = function() {
      var oneTurn, oneTurnAnim, ot, point, pointAnim;
      this.circle([0, 0], this.unit, {
        "class": 'colored line'
      });
      ot = ((function(_this) {
        return function(turns) {
          var x, y, _ref;
          if (turns === 1) {
            return ot(0);
          }
          _ref = _this.pt([1.5 * Math.cos(τ * turns), 1.5 * Math.sin(τ * turns)]), x = _ref[0], y = _ref[1];
          return {
            x: x,
            y: y,
            text: "1 ↺ " + (turns.toFixed(2))
          };
        };
      })(this));
      this.register({
        oneTurn: ot
      });
      oneTurn = this.text([1.3, 0], '1↺0');
      point = this.circle([1, 0], 2, {
        "class": 'colored'
      });
      oneTurn.apply({
        oneTurn: 0
      });
      oneTurnAnim = Raphael.animation({
        oneTurn: 1
      }, 10000, 'linear').repeat(Infinity);
      pointAnim = Raphael.animation({
        transform: "R-360 " + this.origin
      }, 10000, 'linear').repeat(Infinity);
      oneTurn.element.animate(oneTurnAnim);
      return point.element.animateWith(oneTurn.element, oneTurnAnim, pointAnim);
    };

    return OnePlane;

  })(Uriel.Plane);

  $(function() {
    Uriel.diagram('number-line', NumberLine);
    Uriel.diagram('number-plane', NumberPlane);
    Uriel.diagram('complex-plane', ComplexPlane);
    Uriel.diagram('polar-plane', PolarPlane);
    return Uriel.diagram('one-plane', OnePlane);
  });

}).call(this);
