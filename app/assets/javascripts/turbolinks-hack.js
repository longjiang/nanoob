// Try to prevent to reload page on anchor links

$(document).on('turbolinks:click', function (event) {
  if (event.target.getAttribute('href').charAt(0) === '#') {
    return event.preventDefault()
  }
})