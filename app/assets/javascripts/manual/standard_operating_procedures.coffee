haveEditor = ->
  $('#document_body').length

document.addEventListener 'turbolinks:load', ->
  if haveEditor()
    ace_editor = new AceEditor('markdown', 'document_body')

    console.log('keys')

    $(document).on 'click', 'a.todo_item', (e) ->
      e.preventDefault()
      line_number = parseInt $(this).data('line')
      $('#editor_tab').tab('show')
      editor.focus()
      editor.gotoLine line_number

    $(document).on 'click', '#save_standard_operating_procedure', (e) ->
      e.preventDefault()
      $('#manual_standard_operating_procedure_body').val editor.getValue()
      $('form.edit_manual_standard_operating_procedure').submit()
      return
