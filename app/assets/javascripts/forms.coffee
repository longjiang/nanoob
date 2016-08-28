window.updateSlugPrefix = (object) ->
  website_id = $('#blog_' + object + '_business_website_id').val()
  label = $("label[for='blog_" + object + "_slug'] + div > span:first-child")
  label.html loading_placeholder()
  if parseInt(website_id)>0
    $.get("/ws/forms/blog_" + object + "_permalink_prefix", website_id: website_id).done (data) ->
      label.text data.permalink_prefix

window.updateSlug = (object, attr) ->
  website_id = $('#blog_' + object + '_business_website_id').val()
  if attr != ''
    if parseInt(website_id)>0
      $('#blog_' + object + '_slug').val '...'
      $.get('/ws/forms/blog_' + object + '_slug_generator', website_id: website_id, attr: attr).done (data) ->
        $('#blog_' + object + '_slug').val data.slug 
    else
      $('#blog_' + object + '_slug').val ''
      $('#blog_' + object + '_slug').attr('placeholder', 'select website')
      
window.loading_placeholder = () ->
  '<i class="fa fa-spinner fa-pulse" aria-hidden="true"></i>'
        

document.addEventListener 'turbolinks:load', ->
  
  $('#extra_fields').hide()
  $('#published_at_select').hide()
  $('#partner_request_partner_id').select2 theme: "bootstrap" if $('#partner_request_partner_id').is('select')
  $('#partner_backlink_partner_id').select2 theme: "bootstrap" if $('#partner_backlink_partner_id').is('select')
  $('#partner_backlink_partner_request_id').select2 theme: "bootstrap" if $('#partner_backlink_partner_request_id').is('select')
  
  Bootsy.init()
  
  $('#show_extra_fields').click (event) -> 
    event.preventDefault() 
    $('#show_extra_fields').hide()
    $('#extra_fields').show()
    
  $('#show_published_at_select').click (event) -> 
    event.preventDefault() 
    $('#show_published_at_select').hide()
    $('#published_at_select').show()
    
  $('#hide_published_at_select').click (event) -> 
    event.preventDefault() 
    $('#show_published_at_select').show()
    $('#published_at_select').hide()
    
  $('#update_published_at_select').click (event) -> 
    event.preventDefault() 
    $('#blog_post_publish_now').val(false)
    $('#show_published_at_select').hide()
    $('#published_at_select').hide()
    $('.published_at_value').html loading_placeholder()
    attrs = []
    for i in [1..5]
      attrs.push $('#blog_post_published_at_' + i + 'i').val()
    $.get("/ws/forms/blog_post_published_at", date: attrs.join(','), time_zone: 'Beijing').done (data) ->
      $('.published_at_value').text(data.date)
      $('#show_published_at_select').show()
    
  $('.collapse.toggle-chevron').on 'hide.bs.collapse', ->
    $('.toggle-card [href="#' + $(this).attr('id') + '"] i').addClass('fa-chevron-down').removeClass('fa-chevron-up')
    
  $('.collapse.toggle-chevron').on 'show.bs.collapse', ->
    $('.toggle-card [href="#' + $(this).attr('id') + '"] i').addClass('fa-chevron-up').removeClass('fa-chevron-down')

  
  timer = undefined
  delay = 600
  
  $('.new_blog_post #blog_post_title').on 'input', ->
    attr = $(this).val()
    window.clearTimeout timer
    timer = window.setTimeout(( ->
      updateSlug 'post', attr
      ), delay)
    
  $('#blog_post_business_website_id').on 'change', ->
    updateSlugPrefix 'post'
    attr = $('#blog_post_title').val()
    updateSlug 'post', attr
      
  $('.new_blog_category #blog_category_name').on 'input', ->
    attr = $(this).val()
    window.clearTimeout timer
    timer = window.setTimeout(( ->
      updateSlug 'category', attr
      ), delay)
      
  $('#blog_category_business_website_id').on 'change', ->
    updateSlugPrefix 'category', $(this).val()
    attr = $('.new_blog_category #blog_category_name').val()
    updateSlug 'category', attr
    
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
  