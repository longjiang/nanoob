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
  
  timer = undefined
  delay = 600
  
  $('.new_blog_post #blog_post_title').on 'input', ->
    title = $(this).val()
    window.clearTimeout timer
    timer = window.setTimeout(( ->
      $('#blog_post_slug').val '...'
      $.get("/ws/forms/blog_post_slug_generator", title: title).done (data) ->
        $('#blog_post_slug').val data.slug 
      ), delay)
    
  $('#blog_post_business_website_id').on 'change', ->
    website_id = $(this).val()
    label = $("label[for='blog_post_slug'] + div > span:first-child")
    label.text('...')
    $.get("/ws/forms/permalink_prefix", website_id: website_id).done (data) ->
      label.text data.permalink_prefix
    
  $(":file").filestyle({input: false, buttonName: "btn-primary"});
  
  $(document).on "upload:start", "form", (event) ->
    $(this).find("input[type=submit]").attr("disabled", true)
    $(this).find(".file-loading").removeClass('invisible')
    
  $(document).on "upload:complete", "form", (e) ->
    if(!$(this).find("input.uploading").length) 
      $(this).find("input[type=submit]").removeAttr("disabled")
      $(this).find(".file-loading").addClass('invisible')
      renderImage e.target

  renderImage = (fileField) ->
    reader = new FileReader
    reader.onload = (event) ->
      theUrl = event.target.result
      $('img.uploaded_image').attr('src', theUrl)
    
    reader.readAsDataURL fileField.files[0]
  
  return
  