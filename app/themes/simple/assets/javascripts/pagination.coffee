# http://stackoverflow.com/questions/23591673/rails-4-loading-posts-w-jquery-ajax-on-a-load-more-button
jQuery ->
  if $('.infinite-scrolling').size() > 0
    $(window).on 'scroll', ->
      more_posts_url = $('.pagination a.next_page').attr('href')
      if more_posts_url
        $('.pagination').html('<a href="#" class="load-more" >Load More</a>')
        $('.load-more').click (event) ->
          event.preventDefault() # https://api.jquery.com/event.preventdefault/
          $.getScript more_posts_url # https://api.jquery.com/jquery.getscript/
      return
    return
