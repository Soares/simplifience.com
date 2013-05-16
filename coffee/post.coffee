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
      # $.post(meditation.attr('action'), meditation.serialize())
      close()
      return false
    $('a.close', meditation).on 'click', close

  $('#main article [title]').each ->
    elem = $(this)
    tooltip = $('<p class="automatic title"></p>')
    tooltip.addClass elem.prop('tagName').toLowerCase()
    title = elem.attr('title')
      .replace('CC-BY-SA-3.0', '<a href="http://creativecommons.org/licenses/by-sa/3.0/">CC-BY-SA-3.0</a>')
      .replace('CC-BY-SA-2.5', '<a href="http://creativecommons.org/licenses/by-sa/2.5/deed.en">CC-BY-SA-2.5</a>')
      .replace('CC-BY-SA-2.0', '<a href="http://creativecommons.org/licenses/by-sa/2.0/deed.en">CC-BY-SA-2.0</a>')
      .replace('CC-BY-SA-1.0', '<a href="http://creativecommons.org/licenses/by-sa/1.0/deed.en">CC-BY-SA-1.0</a>')
      .replace(/(http:\/\/commons.wikimedia.org\/wiki\/User:)(\S+)/, '<a href="$1$2">$2</a>')
      .replace(/(http:\/\/www.flickr.com\S+)/, '<a href="$1">flickr</a>')
    short = elem.attr('title')
      .replace(/http:\/\/commons.wikimedia.org\/wiki\/User:(\S+)/, '$1')
    tooltip.html title
    elem.attr 'title', short
    elem.after tooltip
