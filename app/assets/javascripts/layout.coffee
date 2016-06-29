document.addEventListener 'turbolinks:load', ->
  $('[data-toggle=offcanvas]').click ->
    $('.row-offcanvas').toggleClass 'active'