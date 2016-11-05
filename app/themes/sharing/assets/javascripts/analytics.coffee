$(document).ready ->
  ahoy.trackClicks()

document.addEventListener 'turbolinks:load', ->
  ahoy.trackView()