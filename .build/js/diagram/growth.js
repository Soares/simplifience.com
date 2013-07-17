// Generated by CoffeeScript 1.6.1
(function() {
  var DISTANCE, FINAL_HOLD, FINAL_WALK, Growth, HEIGHT, HEIGHTUNIT, JUMP_DURATION, PROGRESSION, RECTWIDTH, RESTART_DELAY, SEQUENCE_DELAY, START_DELAY, TICK_DELAY, UNFOCUS_DELAY, UNIT, WALK_DURATION, WIDTH, X0, XPADDING, Y0, YPADDING, growers,
    _this = this,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  WIDTH = 500;

  XPADDING = 50;

  YPADDING = 25;

  HEIGHTUNIT = 60;

  HEIGHT = HEIGHTUNIT * 3 + (2 * YPADDING);

  X0 = XPADDING;

  Y0 = HEIGHT - YPADDING;

  UNIT = WIDTH - 2 * XPADDING;

  RECTWIDTH = 30;

  DISTANCE = UNIT - RECTWIDTH;

  PROGRESSION = ['green', 'teal', 'blue', 'violet', 'red', 'orange', 'yellow'];

  UNFOCUS_DELAY = 500;

  START_DELAY = 500;

  SEQUENCE_DELAY = 1000;

  RESTART_DELAY = 3000;

  JUMP_DURATION = 300;

  TICK_DELAY = 500;

  WALK_DURATION = 2000;

  FINAL_WALK = 3000;

  FINAL_HOLD = 5000;

  growers = [];

  Growth = (function(_super) {

    __extends(Growth, _super);

    function Growth(elem) {
      var _ref,
        _this = this;
      this.continuous = function() {
        return Growth.prototype.continuous.apply(_this, arguments);
      };
      this.next = function(n, m) {
        return Growth.prototype.next.apply(_this, arguments);
      };
      this.compound = function(me, n, m) {
        return Growth.prototype.compound.apply(_this, arguments);
      };
      this.tick = function(n, m) {
        return Growth.prototype.tick.apply(_this, arguments);
      };
      this["do"] = function(index) {
        return Growth.prototype.do.apply(_this, arguments);
      };
      this.guide = function(n) {
        return Growth.prototype.guide.apply(_this, arguments);
      };
      this.focus = function() {
        return Growth.prototype.focus.apply(_this, arguments);
      };
      this.defocus = function() {
        return Growth.prototype.defocus.apply(_this, arguments);
      };
      Growth.__super__.constructor.call(this, elem, WIDTH, HEIGHT);
      this.paper.ca.exp = function(t) {
        var attrs, dy;
        dy = HEIGHTUNIT * (Math.pow(Math.E, t) - 1);
        return attrs = {
          y: Y0 - HEIGHTUNIT - dy,
          height: dy
        };
      };
      this.compounds = (_ref = this.elem.data('compounds')) != null ? _ref : 1;
      if (!_.isArray(this.compounds)) {
        this.compounds = [this.compounds];
      }
      if (this.compounds[0] === 0) {
        this.label = this.text([X0 + DISTANCE + RECTWIDTH / 2, Y0 - 2.82 * HEIGHTUNIT], [
          {
            text: 'n',
            'font-style': 'italic'
          }, " = ∞"
        ]);
      } else {
        this.label = this.text([X0 + DISTANCE + RECTWIDTH / 2, Y0 - 2.82 * HEIGHTUNIT], [
          {
            text: 'n',
            'font-style': 'italic'
          }, " = " + this.compounds[0]
        ]);
      }
      this.axis([X0, Y0], {
        unit: UNIT,
        to: new Uriel.Bound(1, false),
        labels: false,
        tickType: false
      });
      this.guides = this.paper.set(this.guide(1), this.guide(2), this.guide(3));
      this.principle = this.paper.rect(X0, Y0 - HEIGHTUNIT, RECTWIDTH, HEIGHTUNIT);
      this.principle.node.setAttribute('class', 'green');
      this.dollars = this.paper.text(X0 + RECTWIDTH / 2, Y0 - HEIGHTUNIT / 2, '$');
      this.dollars.node.removeAttribute('font');
      this.dollars.node.setAttribute('style', 'font-size:20px;');
      this.dollars.node.setAttribute('class', 'green');
      this.interest = [];
      this.timeouts = [];
      growers.push(this);
      this.defocus();
      this.onView(this.focus, UNFOCUS_DELAY, {
        offset: (function() {
          return $(window).height() / 2;
        }),
        triggerOnce: false
      });
    }

    Growth.prototype.defocus = function() {
      var elem, t, _i, _j, _len, _len1, _ref, _ref1, _results;
      this.elem.addClass('inactive');
      this.principle.stop();
      this.dollars.stop();
      _ref = this.timeouts;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        t = _ref[_i];
        clearTimeout(t);
      }
      _ref1 = this.interest;
      _results = [];
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        elem = _ref1[_j];
        _results.push(elem.stop());
      }
      return _results;
    };

    Growth.prototype.focus = function() {
      var elem, grower, _i, _j, _len, _len1, _ref,
        _this = this;
      if (!this.elem.is('.inactive')) {
        return;
      }
      for (_i = 0, _len = growers.length; _i < _len; _i++) {
        grower = growers[_i];
        if (grower !== this) {
          grower.defocus();
        }
      }
      this.elem.removeClass('inactive');
      this.principle.attr({
        x: X0
      });
      this.dollars.attr({
        x: X0 + RECTWIDTH / 2
      });
      _ref = this.interest;
      for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
        elem = _ref[_j];
        elem.remove();
      }
      return this.timeouts.push(setTimeout((function() {
        return _this["do"](0);
      }), START_DELAY));
    };

    Growth.prototype.guide = function(n) {
      var h, path;
      h = n * HEIGHTUNIT;
      path = this.paper.path("M" + X0 + " " + (Y0 - h) + " l" + UNIT + " 0");
      path.node.setAttribute('class', 'guide');
      return path;
    };

    Growth.prototype["do"] = function(index) {
      var elem, execute, m, _i, _len, _ref, _ref1, _ref2,
        _this = this;
      index = index % this.compounds.length;
      m = this.compounds[index];
      this.principle.attr({
        x: X0
      });
      this.dollars.attr({
        x: X0 + RECTWIDTH / 2
      });
      _ref = this.interest;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        elem = _ref[_i];
        elem.remove();
      }
      if (m === 0 && this.label) {
        if ((_ref1 = this.label.element) != null) {
          _ref1.remove();
        }
        this.label = this.text([X0 + DISTANCE + RECTWIDTH / 2, Y0 - 2.82 * HEIGHTUNIT], [
          {
            text: 'n',
            'font-style': 'italic'
          }, ' = ∞'
        ]);
      } else if (this.label) {
        if ((_ref2 = this.label.element) != null) {
          _ref2.remove();
        }
        this.label = this.text([X0 + DISTANCE + RECTWIDTH / 2, Y0 - 2.82 * HEIGHTUNIT], [
          {
            text: 'n',
            'font-style': 'italic'
          }, " = " + m
        ]);
      }
      execute = function() {
        if (m === 0) {
          return _this.continuous();
        } else {
          return _this.tick(0, m);
        }
      };
      return this.timeouts.push(setTimeout(execute, SEQUENCE_DELAY));
    };

    Growth.prototype.tick = function(n, m) {
      var anim, canvas, compounder, delta, elem, interest, newX, t, _i, _len, _results,
        _this = this;
      if (n >= m) {
        this.timeouts.push(setTimeout((function() {
          return _this["do"](_this.compounds.indexOf(m) + 1);
        }), RESTART_DELAY));
        return;
      }
      delta = DISTANCE / m;
      newX = X0 + ((n + 1) * delta);
      t = WALK_DURATION / m;
      canvas = this;
      compounder = (function() {
        return canvas.compound(this, n, m);
      });
      anim = this.principle.animate({
        x: newX
      }, t, 'linear', compounder);
      this.dollars.animateWith(this.principle, anim, {
        x: newX + RECTWIDTH / 2
      }, t, 'linear');
      this.accumulator = 0;
      interest = (function() {
        var _i, _len, _ref, _results;
        _ref = this.interest;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          elem = _ref[_i];
          _results.push(elem);
        }
        return _results;
      }).call(this);
      _results = [];
      for (_i = 0, _len = interest.length; _i < _len; _i++) {
        elem = interest[_i];
        _results.push(elem.animateWith(this.principle, anim, {
          x: newX
        }, t, 'linear', compounder));
      }
      return _results;
    };

    Growth.prototype.compound = function(me, n, m) {
      var anim, callback, myClass, myHeight, myIndex, myNewY, myY, x, you, yourClass, yourEndY, yourHeight, yourIndex, yourStartY;
      x = me.attr('x');
      myClass = me.node.getAttribute('class');
      myIndex = PROGRESSION.indexOf(myClass);
      myHeight = me.attr('height');
      myY = me.attr('y');
      myNewY = myY - this.accumulator;
      yourIndex = myIndex + 1;
      yourClass = PROGRESSION[yourIndex % PROGRESSION.length];
      yourHeight = myHeight / m;
      yourStartY = myY;
      yourEndY = myNewY - yourHeight;
      you = this.paper.rect(x, yourStartY, RECTWIDTH, yourHeight);
      you.node.setAttribute('class', yourClass);
      you.toBack();
      this.guides.toBack();
      this.accumulator += yourHeight;
      this.interest.splice(this.interest.indexOf(me) + 1, 0, you);
      callback = myIndex === 0 ? this.next(n, m) : null;
      anim = me.animate({
        y: myNewY
      }, JUMP_DURATION, 'backOut', callback);
      return you.animateWith(me, anim, {
        y: yourEndY
      }, JUMP_DURATION, 'backOut');
    };

    Growth.prototype.next = function(n, m) {
      var _this = this;
      return function() {
        return _this.timeouts.push(setTimeout((function() {
          return _this.tick(n + 1, m);
        }), TICK_DELAY));
      };
    };

    Growth.prototype.continuous = function() {
      var anim, attrs, finish, interest,
        _this = this;
      interest = this.paper.rect(X0, Y0 - HEIGHTUNIT, RECTWIDTH, 0);
      interest.attr({
        exp: 0,
        fill: '#009999',
        stroke: '#006363'
      });
      finish = function() {
        return _this.timeouts.push(setTimeout((function() {
          return _this["do"](_this.compounds.length);
        }), FINAL_HOLD));
      };
      attrs = {
        x: X0 + DISTANCE,
        fill: '#7109AA',
        stroke: '#48036F',
        exp: 1
      };
      anim = this.principle.animate({
        x: X0 + DISTANCE
      }, FINAL_WALK, finish);
      this.dollars.animateWith(this.principle, anim, {
        x: X0 + DISTANCE + RECTWIDTH / 2
      }, FINAL_WALK);
      interest.animateWith(this.principle, anim, attrs, FINAL_WALK);
      return this.interest.push(interest);
    };

    return Growth;

  })(Uriel.Diagram);

  $(function() {
    return Uriel.diagram('growth', Growth);
  });

}).call(this);
