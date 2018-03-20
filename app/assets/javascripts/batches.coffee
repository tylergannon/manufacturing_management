resizeChosen = ->
  $('.chosen-container').each ->
    $(this).attr 'style', 'width: 100%'
    return
  return

open_batch_search_modal = ->
  if window.batch_select?
    $('#jump-to-batch .bitches').html(window.batch_select.clone())
    $('#jump-to-batch').modal('show')

  else
    $.getJSON '/batches/search.json', (json) ->
      select_tag = $('<select style="width: 100%;" class="options" />')
      $.each json, (i, obj) ->
        select_tag.append $("<option value=\"#{obj.batch_number}\">#{obj.name}</option>")
      window.batch_select = select_tag
      $('#jump-to-batch .bitches').html(select_tag.clone())

      $('#jump-to-batch').modal('show')


$(document).on 'turbolinks:load', ->

  $('.datepicker').pickadate()

  $(document).on 'shown.bs.modal', '#jump-to-batch', ->
    $('#jump-to-batch select').chosen()

  $(document).on 'change', '#jump-to-batch select', (e) ->
    Turbolinks.visit '/batches/' + $('#jump-to-batch select').val()

  $(document).on 'submit', '#jump-to-batch-form', (e) ->
    e.preventDefault()
    console.log($('#batch_number').val())
    Turbolinks.visit('/batches/' + $('#batch_number').val())
    false

  $(document).on 'click', '#open_batch_modal_link', (e) ->
    e.preventDefault()
    open_batch_search_modal()

  key '⌘+f, shift+f', open_batch_search_modal

  $('select').not('.datetime').not('.no-chosen').not('.edit_batch select').not('.modal select').chosen()

  $('.modal').on 'shown.bs.modal', (e) ->
    $(e.currentTarget).find('select').chosen()
    $('.modal .bitches select').trigger('chosen:open')

  $(window).on 'resize', resizeChosen
