window.updateSlugPrefix = (options) ->
  website_id  = options['website_id']
  label       = $('#' + options['target']).parent().find('span:first-child')
  label.html loading_placeholder()
  if parseInt(website_id)>0
    $.get("/ws/forms/blog_permalink_prefix", website_id: website_id, klass: options['klass']).done (data) ->
      label.text data.permalink_prefix

window.updateSlug = (options) ->
  website_id  = options['website_id']
  label       = options['label']
  slug        = $('#' + options['target'])
  if label != ''
    if parseInt(website_id)>0
      slug.val '...'
      $.get('/ws/forms/blog_slug_generator', website_id: website_id, label: label, klass: options['klass']).done (data) ->
        slug.val data.slug 
    else
      slug.val ''
      slug.attr('placeholder', 'select website')
      
window.loading_placeholder = () ->
  '<i class="fa fa-spinner fa-pulse" aria-hidden="true"></i>'
        

document.addEventListener 'turbolinks:load', ->
  
  $('#extra_fields').hide()
  $('#published_at_select').hide()
  $('#partner_request_partner_id').select2 theme: "bootstrap" if $('#partner_request_partner_id').is('select')
  $('#partner_backlink_partner_id').select2 theme: "bootstrap" if $('#partner_backlink_partner_id').is('select')
  $('#partner_backlink_partner_request_id').select2 theme: "bootstrap" if $('#partner_backlink_partner_request_id').is('select')
  if $('#blog_contents_post_tag_ids').is('select')
    $('#blog_contents_post_tag_ids').select2 
      theme: "bootstrap" 
      tags: true
  
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
    
  $('.edit_blog_page #update_published_at_select, .new_blog_page #update_published_at_select').click (event) -> 
    event.preventDefault() 
    $('#blog_page_publish_now').val(false)
    $('#show_published_at_select').hide()
    $('#published_at_select').hide()
    $('.published_at_value').html loading_placeholder()
    attrs = []
    for i in [1..5]
      attrs.push $('#blog_page_published_at_' + i + 'i').val()
    $.get("/ws/forms/blog_page_published_at", date: attrs.join(','), time_zone: 'Beijing').done (data) ->
      $('.published_at_value').text(data.date)
      $('#show_published_at_select').show()
  
  
  $('.edit_blog_contents_post #update_published_at_select, .new_blog_contents_post #update_published_at_select').click (event) -> 
    event.preventDefault() 
    $('#blog_contents_post_publish_now').val(false)
    $('#show_published_at_select').hide()
    $('#published_at_select').hide()
    $('.published_at_value').html loading_placeholder()
    attrs = []
    for i in [1..5]
      attrs.push $('#blog_contents_post_published_at_' + i + 'i').val()
    $.get("/ws/forms/blog_contents_post_published_at", date: attrs.join(','), time_zone: 'Beijing').done (data) ->
      $('.published_at_value').text(data.date)
      $('#show_published_at_select').show()
    
  $('.collapse.toggle-chevron').on 'hide.bs.collapse', ->
    $('.toggle-card [href="#' + $(this).attr('id') + '"] i').addClass('fa-chevron-down').removeClass('fa-chevron-up')
    
  $('.collapse.toggle-chevron').on 'show.bs.collapse', ->
    $('.toggle-card [href="#' + $(this).attr('id') + '"] i').addClass('fa-chevron-up').removeClass('fa-chevron-down')

  
  timer = undefined
  delay = 600
  
  $("input[updateslug]").on 'input', ->
    website_id = if $('select[updateslug]').length then $('select[updateslug]').val() else $("input[id$='business_website_id']").val()
    options = 
      target:   $(this).attr('updateslug')
      klass:    $(this).data('klass')
      label:    $(this).val()
      website_id: website_id
    window.clearTimeout timer
    timer = window.setTimeout(( ->
      updateSlug options
      ), delay)
  
  $('select[updateslug]').on 'change', ->
    options = 
      target:   $(this).attr('updateslug')
      klass:    $(this).data('klass')
      label:    $("input[updateslug]").val()
      website_id: $(this).val()
    updateSlugPrefix options
    updateSlug options
    
    
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
  