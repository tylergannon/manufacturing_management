haveEditor = ->
  $('#diagram_body').length

ace_editor = null

class Updater
  doRefresh: =>
    $('#refresh_png').click()
  updated: =>
    @changed = false
    @updating = false
  startInterval: =>
    setInterval((=> @doRefresh() if @changed), 1000)
  setupAjaxEventHandler: =>
    $(document).on 'ajax:before', '#refresh_png', =>
      return if @updating
      @updating = true
      $('#refresh_png').data 'params', process_flow_body: @ace_editor.getValue()

  constructor: (@ace_editor) ->
    @changed  = false
    @updating = false
    @ace_editor.editor.on 'change', => @changed = true

    @setupAjaxEventHandler()
    @startInterval()


document.addEventListener 'turbolinks:load', ->


  if haveEditor()
    ace_editor = new AceEditor('yaml', 'diagram_body')

    window.updater = new Updater(ace_editor)

    $(document).on 'change', '#manual_process_flow_layout, #manual_process_flow_aspect_ratio', ->
      ace_editor.quickSave()

    ace_editor.addDataToForm = (form_data) ->
      form_data['aspect_ratio'] = $('#manual_process_flow_aspect_ratio').val()
      form_data['layout'] = $('#manual_process_flow_layout').val()

    Split `['#editor', '#markdown']`,
      sizes: `[45, 55]`
      minSize: 200
      onDragEnd: -> ace_editor.editor.resize()

    ace_editor.editor.resize()
