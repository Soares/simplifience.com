// Generated by CoffeeScript 1.4.0
(function() {
  var SVG_DOCTYPE,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  SVG_DOCTYPE = 'http://www.w3.org/2000/svg';

  this.τ = 2 * Math.PI;

  this.Uriel = {
    diagram: function(classname, diagram, width, height) {
      if (width == null) {
        width = null;
      }
      if (height == null) {
        height = null;
      }
      return $("." + classname).each(function() {
        return new diagram(this, width, height);
      });
    }
  };

  Uriel.Bound = (function() {

    function Bound(end, open) {
      this.end = end;
      this.open = open != null ? open : true;
    }

    return Bound;

  })();

  Uriel.Element = (function() {

    function Element(element, attrs) {
      this.element = element;
      this.animate = __bind(this.animate, this);

      this.apply = __bind(this.apply, this);

      this.apply(attrs);
    }

    Element.prototype.apply = function(attrs) {
      var underlying, _i, _len, _ref;
      attrs = _.extend({}, attrs);
      if (_.isArray(attrs["class"])) {
        attrs["class"] = attrs["class"].join(' ');
      }
      _ref = ['class', 'style'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        underlying = _ref[_i];
        if (attrs[underlying] != null) {
          this.element.node.setAttribute(underlying, attrs[underlying]);
          delete attrs[underlying];
        }
      }
      this.element.attr(attrs);
      return this;
    };

    Element.prototype.animate = function(attrs, controls) {
      var anim, callback, delay, duration;
      if (controls == null) {
        controls = {};
      }
      if (attrs.delay != null) {
        attrs = _.extend({}, attrs);
        delay = controls.duration * attrs.delay;
        delete attrs.delay;
      } else {
        delay = 0;
      }
      callback = !controls.master ? controls.callback : null;
      duration = controls.duration;
      anim = Raphael.animation(attrs, duration, controls.easing, callback);
      if (delay) {
        anim = anim.delay(delay);
      }
      if (controls.repeat != null) {
        anim = anim.repeat(controls.repeat);
      }
      if (controls.master) {
        this.element.animateWith(controls.master[0], controls.master[1], anim);
      } else {
        this.element.animate(anim);
        controls.master = [this.element, anim];
      }
      return this;
    };

    return Element;

  })();

  Uriel.Path = (function(_super) {

    __extends(Path, _super);

    function Path(paper, description, attrs) {
      var element;
      if (description == null) {
        description = null;
      }
      if (attrs == null) {
        attrs = {};
      }
      element = paper.path(description);
      element.node.removeAttribute('style');
      element.node.removeAttribute('fill');
      element.node.removeAttribute('stroke');
      Path.__super__.constructor.call(this, element, attrs);
    }

    return Path;

  })(Uriel.Element);

  Uriel.Circle = (function(_super) {

    __extends(Circle, _super);

    function Circle(paper, _arg, r, attrs) {
      var element, x, y;
      x = _arg[0], y = _arg[1];
      if (attrs == null) {
        attrs = {};
      }
      element = paper.circle(x, y, r);
      element.node.removeAttribute('style');
      element.node.removeAttribute('fill');
      element.node.removeAttribute('stroke');
      Circle.__super__.constructor.call(this, element, attrs);
    }

    return Circle;

  })(Uriel.Element);

  Uriel.Text = (function(_super) {

    __extends(Text, _super);

    function Text(paper, _arg, text, attrs) {
      var element, fontSize, i, part, x, y, _i, _len;
      x = _arg[0], y = _arg[1];
      if (text == null) {
        text = '';
      }
      if (attrs == null) {
        attrs = {};
      }
      this.animate = __bind(this.animate, this);

      this.tspan = __bind(this.tspan, this);

      element = paper.text(x, y, '');
      element.node.removeChild(element.node.lastChild);
      element.node.removeAttribute('style');
      element.node.removeAttribute('fill');
      element.node.removeAttribute('stroke');
      element.node.removeAttribute('font');
      if (attrs['font-size'] == null) {
        attrs['font-size'] = 10;
      }
      fontSize = attrs['font-size'];
      if (!_.isArray(text)) {
        text = [text];
      }
      for (i = _i = 0, _len = text.length; _i < _len; i = ++_i) {
        part = text[i];
        element.node.appendChild(this.tspan(part, fontSize, i));
      }
      delete attrs['font-size'];
      if (attrs['style'] == null) {
        attrs['style'] = '';
      }
      attrs['style'] = "font-size:" + fontSize + ";" + attrs['style'];
      Text.__super__.constructor.call(this, element, attrs);
    }

    Text.prototype.tspan = function(text, fontSize, index) {
      var key, tspan, val;
      if (index == null) {
        index = 0;
      }
      tspan = document.createElementNS(SVG_DOCTYPE, 'tspan');
      if (_.isObject(text)) {
        tspan.appendChild(document.createTextNode(text.text));
        delete text.text;
        for (key in text) {
          val = text[key];
          tspan.setAttribute(key, val);
        }
      } else {
        tspan.appendChild(document.createTextNode(text));
      }
      if (index === 0) {
        tspan.setAttribute('dy', fontSize / 4);
      }
      return tspan;
    };

    Text.prototype.animate = function(attrs, controls) {
      var delay,
        _this = this;
      if (attrs.text != null) {
        delay = attrs.delay ? attrs.delay * attrs.duration : 0;
        setTimeout((function() {
          return _this.apply({
            text: attrs.text
          });
        }), delay);
      }
      return Text.__super__.animate.call(this, attrs, controls);
    };

    return Text;

  })(Uriel.Element);

  Uriel.Axis = (function() {

    function Axis(paper, _arg, options) {
      var extensionLength, n, neglength, negunits, poslength, posunits, _i, _len, _ref, _ref1;
      this.paper = paper;
      this.x0 = _arg[0], this.y0 = _arg[1];
      if (options == null) {
        options = {};
      }
      this.classify = __bind(this.classify, this);

      this.label = __bind(this.label, this);

      this.tick = __bind(this.tick, this);

      this.ticks = __bind(this.ticks, this);

      this.arrow = __bind(this.arrow, this);

      this.line = __bind(this.line, this);

      this.at = __bind(this.at, this);

      options = _.defaults(options, {
        adjustTick: (function(num, type) {
          if (num === options.zero && options.tickType) {
            if (type === 'full') {
              return [1.5, 'full'];
            } else {
              return [1, 'full'];
            }
          } else {
            return [1, type];
          }
        }),
        arrowDimensions: [2, 1 / 2],
        capLength: 1,
        classes: {},
        from: null,
        labels: {},
        step: 1,
        swapLabels: false,
        textOffset: 7,
        tickHeight: 4,
        tickType: 'bottom',
        drawLine: true,
        to: new Uriel.Bound(10, true),
        turns: 0,
        unit: 25,
        zero: 0
      });
      this.classes = _.defaults(options.classes, {
        all: 'axis',
        positive: 'positive',
        zero: 'zero',
        negative: 'negative',
        arrow: 'arrow',
        axis: null
      });
      this.elements = {
        geometry: new Uriel.Group(this.paper),
        ticks: new Uriel.Group(this.paper),
        arrows: new Uriel.Group(this.paper),
        labels: new Uriel.Group(this.paper)
      };
      this.unit = options.unit;
      this.zero = options.zero;
      this.tickHeight = options.tickHeight;
      this.tickType = options.tickType;
      if ((_ref = options.from) == null) {
        options.from = new Uriel.Bound(this.zero, false);
      }
      if (_.isNumber(options.from)) {
        options.from = new Uriel.Bound(options.from);
      }
      if (_.isNumber(options.to)) {
        options.to = new Uriel.Bound(options.to);
      }
      if (options.arrowDimensions) {
        this.arrowLength = options.arrowDimensions[0] * options.tickHeight;
        this.arrowBreadth = options.arrowDimensions[1] * options.tickHeight;
      } else {
        this.arrowLength = 0;
        this.arrowBreadth = 0;
      }
      this.asmuth = Math.cos(τ * options.turns);
      this.attitude = Math.sin(τ * options.turns);
      extensionLength = options.capLength * this.unit - this.arrowLength;
      posunits = options.to.end - this.zero;
      negunits = this.zero - options.from.end;
      poslength = posunits * this.unit;
      if (options.to.open) {
        poslength += extensionLength;
      }
      neglength = negunits * this.unit;
      if (options.from.open) {
        neglength += extensionLength;
      }
      this.start = [this.x0 - this.asmuth * neglength, this.y0 + this.attitude * neglength];
      this.end = [this.x0 + this.asmuth * poslength, this.y0 - this.attitude * poslength];
      if (options.drawLine) {
        this.line();
      }
      if (options.from.open) {
        this.arrow(options.from.end);
      }
      if (options.to.open) {
        this.arrow(options.to.end);
      }
      _ref1 = this.ticks(options.from.end, options.to.end, options.step);
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        n = _ref1[_i];
        this.tick(n, options.adjustTick, {
          lookup: options.labels,
          swap: options.swapLabels,
          offset: options.textOffset
        });
      }
    }

    Axis.prototype.at = function(length) {
      return [this.x0 + this.asmuth * length * this.unit, this.y0 - this.attitude * length * this.unit];
    };

    Axis.prototype.line = function() {
      this.elements.axis = new Uriel.Path(this.paper, ['M'] + this.start + ['L'] + this.end);
      this.classify(this.elements.axis, 'axis');
      return this.elements.geometry.push(this.elements.axis);
    };

    Axis.prototype.arrow = function(n) {
      var length, path, x, y, _ref;
      _ref = n > this.zero ? this.end : this.start, x = _ref[0], y = _ref[1];
      length = (n > this.zero ? 1 : -1) * this.arrowLength;
      path = new Uriel.Path(this.paper, ['M', x + length * this.asmuth, y - length * this.attitude, x - this.arrowBreadth * this.attitude, y - this.arrowBreadth * this.asmuth, x + this.arrowBreadth * this.attitude, y + this.arrowBreadth * this.asmuth, 'z']);
      this.classify(path, 'arrow', n);
      this.elements.arrows.push(path);
      return this.elements.geometry.push(path);
    };

    Axis.prototype.ticks = function(from, to, step) {
      var n, _i, _j, _results, _results1;
      if (_.isNumber(step)) {
        _results = [];
        for (n = _i = from; from <= to ? _i <= to : _i >= to; n = _i += step) {
          _results.push(n);
        }
        return _results;
      } else {
        _results1 = [];
        for (n = _j = from; from <= to ? _j <= to : _j >= to; n = from <= to ? ++_j : --_j) {
          if (step(n)) {
            _results1.push(n);
          }
        }
        return _results1;
      }
    };

    Axis.prototype.tick = function(n, adjust, labelOptions) {
      var bottom, dx, dy, factor, path, result, top, type, x, y, _ref, _ref1;
      _ref = _.isFunction(adjust) ? (result = adjust(n, this.tickType), result === true ? result = [1, this.tickType] : void 0, result === false ? result = [0, false] : void 0, result) : [1, this.tickType], factor = _ref[0], type = _ref[1];
      _ref1 = this.at(n - this.zero), x = _ref1[0], y = _ref1[1];
      dx = this.tickHeight * factor * this.attitude;
      dy = this.tickHeight * factor * this.asmuth;
      top = type === 'full' || type === 'top' ? [x - dx, y - dy] : [x, y];
      bottom = type === 'full' || type === 'bottom' ? [x + dx, y + dy] : [x, y];
      if (type !== false) {
        path = new Uriel.Path(this.paper, ['M'] + top + ['L'] + bottom);
        this.classify(path, 'tick', n);
        this.elements.ticks.push(path);
        this.elements.geometry.push(path);
      }
      return this.label(n, top, bottom, labelOptions);
    };

    Axis.prototype.label = function(n, top, bottom, options) {
      var label, offset, point, text, x, y;
      if (!options.lookup) {
        return;
      }
      point = bottom;
      if (this.tickType === 'top' && !options.swap) {
        point = top;
      }
      if (this.tickType !== 'top' && options.swap) {
        point = top;
      }
      label = _.isFunction(options.lookup) ? options.lookup(n) : _.has(options.lookup, n) ? options.lookup[n] : n;
      if (!((label != null) && label !== false)) {
        return;
      }
      offset = _.isFunction(options.offset) ? options.offset(n) : options.offset;
      if (point === top) {
        offset *= -1;
      }
      x = point[0] + offset * this.attitude;
      y = point[1] + offset * this.asmuth;
      text = new Uriel.Text(this.paper, [x, y], label);
      this.classify(text, 'label', n);
      return this.elements.labels.push(text);
    };

    Axis.prototype.classify = function(el, type, n) {
      var addClasses, classes;
      if (n == null) {
        n = null;
      }
      classes = [];
      addClasses = function(cls) {
        if (_.isString(cls)) {
          return classes.push(cls);
        } else {
          return classes = classes.concat(cls);
        }
      };
      addClasses(this.classes.all);
      addClasses(this.classes[type]);
      if (n === this.zero) {
        addClasses(this.classes.zero);
      }
      if (n > this.zero) {
        addClasses(this.classes.positive);
      }
      if (n < this.zero) {
        addClasses(this.classes.negative);
      }
      return el.apply({
        'class': classes.join(' ')
      });
    };

    return Axis;

  })();

  Uriel.Group = (function(_super) {

    __extends(Group, _super);

    function Group(paper, objects, attrs) {
      var set;
      if (objects == null) {
        objects = [];
      }
      if (attrs == null) {
        attrs = {};
      }
      this.animate = __bind(this.animate, this);

      this.apply = __bind(this.apply, this);

      this.remove = __bind(this.remove, this);

      this.add = __bind(this.add, this);

      this.pop = __bind(this.pop, this);

      this.push = __bind(this.push, this);

      set = paper.set();
      this.elements = [];
      Group.__super__.constructor.call(this, set, attrs);
      this.add(objects);
    }

    Group.prototype.push = function(object) {
      this.element.push(object.element);
      return this.elements.push(object);
    };

    Group.prototype.pop = function(object) {
      this.element.exclude(object.element);
      return _.reject(this.elements, (function(o) {
        return o === object;
      }));
    };

    Group.prototype.add = function(objects) {
      var object, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = objects.length; _i < _len; _i++) {
        object = objects[_i];
        _results.push(this.push(object));
      }
      return _results;
    };

    Group.prototype.remove = function(objects) {
      var object, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = objects.length; _i < _len; _i++) {
        object = objects[_i];
        _results.push(this.pop(object));
      }
      return _results;
    };

    Group.prototype.apply = function(attrs) {
      return _.map(this.elements, function(elem) {
        return elem.apply(attrs);
      });
    };

    Group.prototype.animate = function(attrs, controls) {
      return _.map(this.elements, function(elem) {
        return controls.master = elem.animate(attrs, controls);
      });
    };

    return Group;

  })(Uriel.Element);

  Uriel.Animation = (function() {

    function Animation(description, duration, easing, repeat) {
      var add, d, _i, _len,
        _this = this;
      this.duration = duration;
      this.easing = easing;
      this.repeat = repeat;
      this.run = __bind(this.run, this);

      this.description = [];
      add = function(item) {
        var i, _i, _len, _results;
        if (_.isFunction(item)) {
          return _this.description.push(item);
        }
        if (_.isNumber(item)) {
          throw "Animations can't be numbers: " + item;
        }
        if (_.isString(item)) {
          throw "Animations can't be strings: " + item;
        }
        if (!_.isArray(item)) {
          throw "Animations can't be objects:  " + item;
        }
        if (!(item.length && item[0])) {
          return;
        }
        if (_.isArray(item[0])) {
          _results = [];
          for (_i = 0, _len = item.length; _i < _len; _i++) {
            i = item[_i];
            _results.push(add(i));
          }
          return _results;
        } else {
          return _this.description.push(item);
        }
      };
      for (_i = 0, _len = description.length; _i < _len; _i++) {
        d = description[_i];
        add(d);
      }
    }

    Animation.prototype.run = function(callback) {
      var attributes, calledback, controls, description, object, _i, _len, _ref;
      controls = {
        callback: callback,
        duration: this.duration,
        easing: this.easing,
        repeat: this.repeat,
        master: null
      };
      calledback = false;
      _ref = this.description;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        description = _ref[_i];
        if (_.isArray(description)) {
          object = description[0], attributes = description[1];
          if (!object) {
            throw "I thought we filtered out null objects?";
          }
          object.animate(attributes, controls);
          calledback = true;
        } else if (_.isFunction(description)) {
          description(controls);
        } else {
          throw "What even is this? " + description;
        }
      }
      if (!calledback) {
        return setTimeout(callback, this.duration);
      }
    };

    return Animation;

  })();

  Uriel.LinearRecipe = (function() {

    function LinearRecipe(elem, initial, description, loop) {
      this.initial = initial;
      this.description = description;
      this.loop = loop != null ? loop : false;
      this.reset = __bind(this.reset, this);

      this.executeFrom = __bind(this.executeFrom, this);

      this.first = __bind(this.first, this);

      this.triggerOnView = __bind(this.triggerOnView, this);

      this.trigger = __bind(this.trigger, this);

      this.elem = $(elem);
      this.initial.run();
    }

    LinearRecipe.prototype.trigger = function(delay) {
      var proceed;
      if (delay == null) {
        delay = null;
      }
      proceed = this.executeFrom(0);
      if (delay != null) {
        return setTimeout(proceed, delay);
      } else {
        return proceed();
      }
    };

    LinearRecipe.prototype.triggerOnView = function(delay, options) {
      var _this = this;
      if (delay == null) {
        delay = null;
      }
      if (options == null) {
        options = {};
      }
      _.defaults(options, {
        offset: 'bottom-in-view',
        triggerOnce: true
      });
      return this.elem.waypoint((function() {
        return _this.trigger(delay);
      }), options);
    };

    LinearRecipe.prototype.first = function() {
      if (_.isNumber(this.description[0])) {
        return 1;
      } else {
        return 0;
      }
    };

    LinearRecipe.prototype.executeFrom = function(i) {
      var _this = this;
      return function(delay) {
        var proceed;
        if (delay == null) {
          delay = null;
        }
        if (_.isNumber(_this.description[i])) {
          if (delay == null) {
            delay = _this.description[i];
          }
          i++;
        }
        proceed = function() {
          if (i >= _this.description.length) {
            return _this.reset();
          }
          return _this.description[i].run(_this.executeFrom(i + 1));
        };
        if (delay != null) {
          return setTimeout(proceed, delay);
        } else {
          return proceed();
        }
      };
    };

    LinearRecipe.prototype.reset = function() {
      if (!_.isNumber(this.loop)) {
        return;
      }
      this.initial.run();
      return this.trigger(this.loop);
    };

    return LinearRecipe;

  })();

  Uriel.Diagram = (function() {

    function Diagram(elem, width, height) {
      this.elem = elem;
      this.width = width != null ? width : 500;
      this.height = height != null ? height : 300;
      this.onView = __bind(this.onView, this);

      this.group = __bind(this.group, this);

      this.text = __bind(this.text, this);

      this.axis = __bind(this.axis, this);

      this.path = __bind(this.path, this);

      this.circle = __bind(this.circle, this);

      this.recipe = __bind(this.recipe, this);

      this.animation = __bind(this.animation, this);

      this.register = __bind(this.register, this);

      this.elem = $(elem);
      width = this.elem.width();
      this.paper = new Raphael(elem, width, width * this.height / this.width);
      this.paper.setViewBox(0, 0, this.width, this.height);
    }

    Diagram.prototype.register = function(object) {
      var key, value, _results;
      _results = [];
      for (key in object) {
        value = object[key];
        _results.push(this.paper.ca[key] = value);
      }
      return _results;
    };

    Diagram.prototype.animation = function() {
      var description,
        _this = this;
      description = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return function(duration, easing, repeat) {
        if (duration == null) {
          duration = 0;
        }
        if (easing == null) {
          easing = '<>';
        }
        if (repeat == null) {
          repeat = false;
        }
        return new Uriel.Animation(description, duration, easing, repeat);
      };
    };

    Diagram.prototype.recipe = function(initial, description, loopAfter) {
      if (loopAfter == null) {
        loopAfter = null;
      }
      return new Uriel.LinearRecipe(this.elem, initial, description, loopAfter);
    };

    Diagram.prototype.circle = function(center, r, attrs) {
      if (attrs == null) {
        attrs = {};
      }
      return new Uriel.Circle(this.paper, center, r, attrs);
    };

    Diagram.prototype.path = function(description, attrs) {
      if (attrs == null) {
        attrs = {};
      }
      return new Uriel.Path(this.paper, description, attrs);
    };

    Diagram.prototype.axis = function(origin, attrs) {
      return new Uriel.Axis(this.paper, origin, attrs);
    };

    Diagram.prototype.text = function(position, text, attrs) {
      return new Uriel.Text(this.paper, position, text, attrs);
    };

    Diagram.prototype.group = function(objects, attrs) {
      return new Uriel.Group(this.paper, objects, attrs);
    };

    Diagram.prototype.onView = function(callback, delay, options) {
      var cb;
      if (delay == null) {
        delay = 0;
      }
      if (options == null) {
        options = {};
      }
      _.defaults(options, {
        offset: 'bottom-in-view',
        triggerOnce: true
      });
      cb = (function() {
        if (delay) {
          return setTimeout(callback, delay);
        } else {
          return callback();
        }
      });
      return this.elem.waypoint(cb, options);
    };

    return Diagram;

  })();

  Uriel.OriginPoint = (function() {

    function OriginPoint(canvas, position, color) {
      var path;
      this.canvas = canvas;
      if (color == null) {
        color = 'red';
      }
      this.moveTo = __bind(this.moveTo, this);

      this.animate = __bind(this.animate, this);

      path = "M" + this.canvas.origin + " L" + (this.canvas.pt(position));
      this.line = this.canvas.path(path, {
        "class": color
      });
      this.dot = this.canvas.circle(position, 4, {
        "class": color
      });
    }

    OriginPoint.prototype.animate = function(attrs, controls) {
      this.line.animate(attrs, controls);
      return this.dot.animate(attrs, controls);
    };

    OriginPoint.prototype.moveTo = function(position) {
      var end;
      end = this.canvas.pt(position);
      return [
        [
          this.dot, {
            cx: end[0],
            cy: end[1]
          }
        ], [
          this.line, {
            path: "M" + this.canvas.origin + " L" + end
          }
        ]
      ];
    };

    return OriginPoint;

  })();

  Uriel.Plane = (function(_super) {

    __extends(Plane, _super);

    function Plane(elem, options) {
      var _ref, _ref1, _ref2, _ref3;
      this.elem = elem;
      if (options == null) {
        options = {};
      }
      this.point = __bind(this.point, this);

      this.line = __bind(this.line, this);

      this.circle = __bind(this.circle, this);

      this.text = __bind(this.text, this);

      this.pt = __bind(this.pt, this);

      this.guide = __bind(this.guide, this);

      this.rule = __bind(this.rule, this);

      this.drawGuides = __bind(this.drawGuides, this);

      this.makeVerticalAxis = __bind(this.makeVerticalAxis, this);

      this.makeHorizontalAxis = __bind(this.makeHorizontalAxis, this);

      this.setupAnimations = __bind(this.setupAnimations, this);

      this.addComponents = __bind(this.addComponents, this);

      this.labelZero = __bind(this.labelZero, this);

      this.width = (_ref = options.width) != null ? _ref : 500;
      this.height = (_ref1 = options.height) != null ? _ref1 : 500;
      this.unit = (_ref2 = options.unit) != null ? _ref2 : 35;
      this.origin = (_ref3 = options.origin) != null ? _ref3 : [this.width / 2, this.height / 2];
      Plane.__super__.constructor.call(this, this.elem, this.width, this.height);
      this.makeHorizontalAxis();
      this.makeVerticalAxis();
      this.labelZero();
      this.drawGuides();
      this.setup();
    }

    Plane.prototype.labelZero = function() {};

    Plane.prototype.addComponents = function() {};

    Plane.prototype.setupAnimations = function() {};

    Plane.prototype.makeHorizontalAxis = function(options) {
      var _ref, _ref1, _ref2, _ref3;
      if (options == null) {
        options = {};
      }
      if ((_ref = options.unit) == null) {
        options.unit = this.unit;
      }
      if ((_ref1 = options.from) == null) {
        options.from = -5;
      }
      if ((_ref2 = options.to) == null) {
        options.to = 5;
      }
      if ((_ref3 = options.labels) == null) {
        options.labels = function(num) {
          if (num !== 0) {
            return num;
          } else {
            return false;
          }
        };
      }
      return this.axis(this.origin, options);
    };

    Plane.prototype.makeVerticalAxis = function(options) {
      var _ref, _ref1, _ref2, _ref3, _ref4, _ref5;
      if (options == null) {
        options = {};
      }
      if ((_ref = options.unit) == null) {
        options.unit = this.unit;
      }
      if ((_ref1 = options.from) == null) {
        options.from = -5;
      }
      if ((_ref2 = options.to) == null) {
        options.to = 5;
      }
      if ((_ref3 = options.labels) == null) {
        options.labels = function(num) {
          if (num !== 0) {
            return num;
          } else {
            return false;
          }
        };
      }
      if ((_ref4 = options.turns) == null) {
        options.turns = 1 / 4;
      }
      if ((_ref5 = options.tickType) == null) {
        options.tickType = 'top';
      }
      return this.axis(this.origin, options);
    };

    Plane.prototype.drawGuides = function() {};

    Plane.prototype.rule = function(end, start) {
      if (start == null) {
        start = [0, 0];
      }
      return this.path("M" + (this.pt(start)) + " L" + (this.pt(end)), {
        "class": 'guide'
      });
    };

    Plane.prototype.guide = function(radius, center) {
      if (center == null) {
        center = [0, 0];
      }
      return this.circle(center, radius * this.unit, {
        "class": 'guide'
      });
    };

    Plane.prototype.pt = function(_arg) {
      var x, y;
      x = _arg[0], y = _arg[1];
      return [this.origin[0] + x * this.unit, this.origin[1] - y * this.unit];
    };

    Plane.prototype.text = function(pt, text, attrs) {
      return Plane.__super__.text.call(this, this.pt(pt), text, attrs);
    };

    Plane.prototype.circle = function(pt, r, attrs) {
      return Plane.__super__.circle.call(this, this.pt(pt), r, attrs);
    };

    Plane.prototype.line = function(start, end, attrs) {
      return this.path(['M'] + this.pt(start) + ['L'] + this.pt(end), attrs);
    };

    Plane.prototype.point = function(pt, color) {
      if (color == null) {
        color = 'red';
      }
      return new Uriel.OriginPoint(this, pt, color);
    };

    return Plane;

  })(Uriel.Diagram);

}).call(this);
