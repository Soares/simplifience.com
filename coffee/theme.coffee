@setTheme = (cls) ->
  $('body').attr('class', cls)
  $('#favicon').attr('href', "/icons/#{cls}.png")
  window.scrollTo(0)
