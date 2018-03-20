# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

is_dirty = false

document.addEventListener 'turbolinks:load', ->
  $(document).on 'click', '.shipping_preparations .toggle_collapse', (e) ->
    if is_dirty
      bootbox.alert('Please save changes before continuing.')
    else
      $('.collapse.in').collapse('hide')
      $(e.currentTarget.dataset.target).collapse('show')
    return

  $(document).on 'change', '.shipping_preparations :input', -> is_dirty = true
