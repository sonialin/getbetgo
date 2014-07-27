# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  if $('#post_subcategory_id :selected').text()
    $('#post_subcategory_id').parent().show()
  else
    $('#post_subcategory_id').parent().hide()
  subcategories = $('#post_subcategory_id').html()
  $('#post_category_id').change ->
    category = $('#post_category_id :selected').text()
    escaped_category = category.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(subcategories).filter("optgroup[label='#{escaped_category}']").html()
    if options
      $('#post_subcategory_id').html(options)
      $('#post_subcategory_id').parent().show()
    else
      $('#post_subcategory_id').empty()
      $('#post_subcategory_id').parent().hide()