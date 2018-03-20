# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  $(document).on 'click', 'a.save-project-status', (e) ->
    e.preventDefault()
    $card_element = $(this).parents('.dashboard_project')
    data = dashboard_project:
      status_color: $card_element.data('color')
      current_status: $card_element.find('.current_status').html()

    $.ajax
      type: 'PATCH'
      url: $card_element.data('url')
      dataType: 'json'
      contentType: 'application/json'
      data: JSON.stringify(data)


  $(document).on 'click', 'a.set-color', (e) ->
    e.preventDefault()
    $this = $(this)
    new_color = $(this).data('color')
    $title = $this.parent()
    $title.removeClass("red yellow green")
    $title.addClass(new_color)
    $this.parents('.dashboard_project').data('color', new_color)
