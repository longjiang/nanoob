document.addEventListener 'turbolinks:load', ->
  $('#partner_request_partner_id').select2 theme: "bootstrap" if $('#partner_request_partner_id').is('select')
  Bootsy.init()
  