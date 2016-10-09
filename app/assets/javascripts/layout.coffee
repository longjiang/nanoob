document.addEventListener 'turbolinks:load', ->
  $('[data-toggle=sidebar]').click ->
    $('#sidebar').toggleClass 'active'