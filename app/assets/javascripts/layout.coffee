document.addEventListener 'turbolinks:load', ->
  $('[data-toggle]').click ->
    $('#' + $(this).data('toggle')).toggleClass 'active'