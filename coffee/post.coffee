$ ->
  page = $('body')

  $('a.meditation').each ->
    meditator = $(this)
    meditation = meditator.parent('p').next('form.meditate')
    response = $('textarea', meditation)
    meditator.on 'click', ->
      page.addClass('meditating')
      meditation.show(0, -> response.focus())
    close = (e) ->
      page.removeClass('meditating')
      meditation.hide()
      return false
    meditation.on 'submit', ->
      $.post(meditation.attr('action'), meditation.serialize())
      close()
      return false
    $('a.close', meditation).on 'click', close
