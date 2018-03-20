
class AceEditor
  constructor: (@mode, @element_id) ->
    @editor = ace.edit(@element_id)
    @selector = '#' + @element_id
    @form_key = $(@selector).data('form-key')
    @editor.setTheme('ace/theme/' + @getCurrentEditorTheme())
    session = @editor.getSession()
    session.setMode('ace/mode/' + @mode)
    session.setTabSize(2)
    session.setUseSoftTabs(true)
    @setEditorFontSize(@editor)
    window.editor = @editor
    @configureForm()
    @configureCommands()
    if localStorage.key(@getDocumentKey())
      @confirmUseVersionInLocalStorage()
    setInterval((=> @quickSave()), 1000 * 60 * 5)
    @configureSaveAndExit()
    @configureKeyCombinations()
    @configureShowHelp()
    @editor.focus()

  getValue: =>
    @editor.getValue()

  setEditorFontSize: (e) ->
    newFontSize = parseInt($('#editor_font_size').val())
    e.setFontSize(newFontSize)

  resizeEditor: ->
    height = document.documentElement.clientHeight - $(@selector)[0].offsetTop
    $(@selector).css('height', height)
    @editor.resize()

  configureKeyCombinations: ->
    key '⌘+shift+x', => @saveAndExit()
    key '⌘+shift+s', => @quickSave()
    key '⌘+/', => @toggleHeader()
    key '⌘+.', => @toggleCollapseMenu()
    key '⌘+k', => @showHelpMenu()

  getCurrentEditorTheme: ->
    $('#theme_select option:selected').text()

  configureForm: ->
    $(document).on 'change', '#theme_select', (e) =>
      @editor.setTheme 'ace/theme/' + @getCurrentEditorTheme()
    $(document).on 'change', '#editor_font_size', =>
      @setEditorFontSize(@editor)

  toggleHeader: =>
    $('#header').toggleClass('hidden-xs-up')
    @resizeEditor()

  toggleCollapseMenu: ->
    $('#collapse_menu').click()
    setTimeout((=> @resizeEditor()), 1500)

  showHelpMenu: ->
    bootbox.alert(HandlebarsTemplates['keyboard_shortcuts']())

  addDataToForm: (a) ->

  quickSave: =>
    data = {}
    json = JSON.stringify @editor.getValue()
    data[@form_key] = body: json
    @addDataToForm(data[@form_key])
    $.ajax
      type: 'PATCH'
      url: $(@selector).data('url')
      dataType: 'script'
      error: =>
        localStorage.setItem(getDocumentKey(), @editor.getValue())
        Alerts.flash('Had a problem saving document. I\'ve stashed your changes locally in case you have to reload', 'error')
      data: data

  getDocumentKey: =>
    'process_flow' + $(@selector).data('id')

  saveAndExit: =>
    $('.save.' + @form_key).click()

  configureSaveAndExit: =>
    $(document).on 'click', '.save.' + @form_key, (e) =>
      e.preventDefault()
      $('#' + @form_key + '_body').val editor.getValue()
      $('form.edit_' + @form_key).submit()
      return

  configureShowHelp: ->
    $(document).on 'click', '#show_help_menu', (e) =>
      e.preventDefault()
      @showHelpMenu()

  configureCommands: =>
    @editor.commands.addCommand
      name: 'quicksave'
      bindKey:
        win: 'Ctrl-Shift-S'
        mac: 'Command-Shift-S'
      exec: (editor) =>
        @quickSave()

    @editor.commands.addCommand
      name: 'show-hide-header'
      bindKey:
        win: 'Ctrl-/'
        mac: 'Command-/'
      exec: (editor) =>
        @toggleHeader()

    @editor.commands.addCommand
      name: 'show-hide-menu'
      bindKey:
        win: 'Ctrl-.'
        mac: 'Command-.'
      exec: (editor) =>
        @toggleCollapseMenu()

    @editor.commands.addCommand
      name: 'show-help-menu'
      bindKey:
        win: 'Ctrl-.'
        mac: 'Command-k'
      exec: (editor) =>
        @showHelpMenu()

    @editor.commands.addCommand
      name: 'save-and-exit'
      bindKey:
        win: 'Ctrl-Shift-X'
        mac: 'Command-Shift-X'
      exec: (editor) =>
        @saveAndExit()

  confirmUseVersionInLocalStorage: =>
    bootbox.confirm
      message: 'Revert to locally stored version of document?'
      buttons:
        confirm:
          label: 'Yes'
          className: 'btn-primary'
        cancel:
          label: 'No'
          className: 'btn-warning'
      callback: (result) =>
        if result
          @editor.setValue localStorage.getItem(@getDocumentKey())
          Alerts.flash('Reverted Document')
        else
          Alerts.flash('Dropping stashed version.')
        localStorage.removeItem(@getDocumentKey())
        return


window.AceEditor = AceEditor
