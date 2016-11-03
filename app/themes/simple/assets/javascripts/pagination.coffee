jQuery ->
  if $('.infinite-scrolling').size() > 0
    $(window).on 'scroll', ->
      more_posts_url = $('.pagination a.next_page').attr('href')
      if more_posts_url
        $('.pagination').html('<a href="#" class="load-more" >Load More</a>')
        $('.load-more').click (event) ->
          event.preventDefault()
          $.getScript more_posts_url
      return
    return
