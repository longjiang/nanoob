document.addEventListener 'turbolinks:load', ->
  $('#extra_fields').hide()
  $('#partner_request_partner_id').select2 theme: "bootstrap" if $('#partner_request_partner_id').is('select')
  $('#partner_backlink_partner_id').select2 theme: "bootstrap" if $('#partner_backlink_partner_id').is('select')
  $('#partner_backlink_partner_request_id').select2 theme: "bootstrap" if $('#partner_backlink_partner_request_id').is('select')
  Bootsy.init()
  $('#show_extra_fields').click (event) -> 
    event.preventDefault() 
    $('#show_extra_fields').hide()
    $('#extra_fields').show()
    
    
  return
  