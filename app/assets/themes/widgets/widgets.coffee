document.addEventListener 'turbolinks:load', ->
  
  $(document).on 'click', 'a[href^="/widgets/posts"]' , -> 
    $(this).parents('.panel').first().find('.collapse').html('loading...').collapse()