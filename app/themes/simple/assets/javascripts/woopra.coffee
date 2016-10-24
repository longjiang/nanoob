window.metawoopra = ->
  $("woopra").each ->
    params = $(this).attr('params')
    if params
      woopra.track $(this).attr('event'), $.parseJSON($(this).attr('params'))
    else
      woopra.track()
      

document.addEventListener 'turbolinks:load', ->
  metawoopra()
  
# class @Woopra
#
#   @load: ->
#     document.addEventListener "page:change", (->
#
#       $("meta[name='woopra']").each ->
#         params = $(this).attr('params')
#         if params
#           woopra.track $(this).attr('event'), $.parseJSON($(this).attr('params'))
#         else
#           woopra.track()
#
#
#       )
#
#
# Woopra.load()
