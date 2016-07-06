document.addEventListener 'turbolinks:load', ->
  $(document).on "click", '.pagination a[data-remote=true]', ->
    $('table.loading tbody').addClass('loading')
    history.pushState(null, '', $(this).attr("href"))
    
  $(window).on 'popstate', ->
      remoteUrl = "<a href='" + document.location.href + "'" + " data-remote='true'></a>"
      $.rails.handleRemote( $(remoteUrl) )
