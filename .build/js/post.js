// Generated by CoffeeScript 1.4.0
(function() {

  $(function() {
    var page;
    page = $('body');
    return $('a.meditation').each(function() {
      var close, meditation, meditator, response;
      meditator = $(this);
      meditation = meditator.parent('p').next('form.meditate');
      response = $('textarea', meditation);
      meditator.on('click', function() {
        page.addClass('meditating');
        return meditation.show(0, function() {
          return response.focus();
        });
      });
      close = function(e) {
        page.removeClass('meditating');
        meditation.hide();
        return false;
      };
      meditation.on('submit', function() {
        $.post(meditation.attr('action'), meditation.serialize());
        close();
        return false;
      });
      return $('a.close', meditation).on('click', close);
    });
  });

}).call(this);
