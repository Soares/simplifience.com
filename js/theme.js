// Generated by CoffeeScript 1.7.1
(function() {
  this.setTheme = function(cls) {
    $('body').attr('class', cls);
    $('#favicon').attr('href', "/icons/" + cls + ".png");
    return window.scrollTo(0);
  };

}).call(this);
