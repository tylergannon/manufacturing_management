###*
# bootbox.js [master branch]
#
# http://bootboxjs.com/license.txt
###

# @see https://github.com/makeusabrew/bootbox/issues/180
# @see https://github.com/makeusabrew/bootbox/issues/186
((root, factory) ->
  'use strict'
  if typeof define == 'function' and define.amd
    # AMD. Register as an anonymous module.
    define [ 'jquery' ], factory
  else if typeof exports == 'object'
    # Node. Does not work with strict CommonJS, but
    # only CommonJS-like environments that support module.exports,
    # like Node.
    module.exports = factory(require('jquery'))
  else
    # Browser globals (root is window)
    root.bootbox = factory(root.jQuery)
  return
) window, ($) ->

  ###*
  # @private
  ###

  _t = (key) ->
    locale = locales[defaults.locale]
    if locale then locale[key] else locales.en[key]

  processCallback = (e, dialog, callback) ->
    e.stopPropagation()
    e.preventDefault()
    # by default we assume a callback will get rid of the dialog,
    # although it is given the opportunity to override this
    # so, if the callback can be invoked and it *explicitly returns false*
    # then we'll set a flag to keep the dialog active...
    preserveDialog = $.isFunction(callback) and callback.call(dialog, e) == false
    # ... otherwise we'll bin it
    if !preserveDialog
      dialog.modal 'hide'
    return

  getKeyLength = (obj) ->
    # @TODO defer to Object.keys(x).length if available?
    k = undefined
    t = 0
    for k of obj
      `k = k`
      t++
    t

  each = (collection, iterator) ->
    index = 0
    $.each collection, (key, value) ->
      iterator key, value, index++
      return
    return

  sanitize = (options) ->
    buttons = undefined
    total = undefined
    if typeof options != 'object'
      throw new Error('Please supply an object of options')
    if !options.message
      throw new Error('Please specify a message')
    # make sure any supplied options take precedence over defaults
    options = $.extend({}, defaults, options)
    if !options.buttons
      options.buttons = {}
    buttons = options.buttons
    total = getKeyLength(buttons)
    each buttons, (key, button, index) ->
      if $.isFunction(button)
        # short form, assume value is our callback. Since button
        # isn't an object it isn't a reference either so re-assign it
        button = buttons[key] = callback: button
      # before any further checks make sure by now button is the correct type
      if $.type(button) != 'object'
        throw new Error('button with key ' + key + ' must be an object')
      if !button.label
        # the lack of an explicit label means we'll assume the key is good enough
        button.label = key
      if !button.className
        if total <= 2 and index == total - 1
          # always add a primary to the main option in a two-button dialog
          button.className = 'btn-primary'
        else
          button.className = 'btn-default'
      return
    options

  ###*
  # map a flexible set of arguments into a single returned object
  # if args.length is already one just return it, otherwise
  # use the properties argument to map the unnamed args to
  # object properties
  # so in the latter case:
  # mapArguments(["foo", $.noop], ["message", "callback"])
  # -> { message: "foo", callback: $.noop }
  ###

  mapArguments = (args, properties) ->
    argn = args.length
    options = {}
    if argn < 1 or argn > 2
      throw new Error('Invalid argument length')
    if argn == 2 or typeof args[0] == 'string'
      options[properties[0]] = args[0]
      options[properties[1]] = args[1]
    else
      options = args[0]
    options

  ###*
  # merge a set of default dialog options with user supplied arguments
  ###

  mergeArguments = (defaults, args, properties) ->
    $.extend true, {}, defaults, mapArguments(args, properties)

  ###*
  # this entry-level method makes heavy use of composition to take a simple
  # range of inputs and return valid options suitable for passing to bootbox.dialog
  ###

  mergeDialogOptions = (className, labels, properties, args) ->
    #  build up a base set of dialog properties
    baseOptions =
      className: 'bootbox-' + className
      buttons: createLabels.apply(null, labels)
    # ensure the buttons properties generated, *after* merging
    # with user args are still valid against the supplied labels
    validateButtons mergeArguments(baseOptions, args, properties), labels

  ###*
  # from a given list of arguments return a suitable object of button labels
  # all this does is normalise the given labels and translate them where possible
  # e.g. "ok", "confirm" -> { ok: "OK, cancel: "Annuleren" }
  ###

  createLabels = ->
    buttons = {}
    i = 0
    j = arguments.length
    while i < j
      argument = arguments[i]
      key = argument.toLowerCase()
      value = argument.toUpperCase()
      buttons[key] = label: _t(value)
      i++
    buttons

  validateButtons = (options, buttons) ->
    allowedButtons = {}
    each buttons, (key, value) ->
      allowedButtons[value] = true
      return
    each options.buttons, (key) ->
      if allowedButtons[key] == undefined
        throw new Error('button key ' + key + ' is not allowed (options are ' + buttons.join('\n') + ')')
      return
    options

  'use strict'
  # the base DOM structure needed to create a modal
  templates =
    dialog: '<div class=\'bootbox modal\' tabindex=\'-1\' role=\'dialog\' aria-hidden=\'true\'>' + '<div class=\'modal-dialog\'>' + '<div class=\'modal-content\'>' + '<div class=\'modal-body\'><div class=\'bootbox-body\'></div></div>' + '</div>' + '</div>' + '</div>'
    header: '<div class=\'modal-header\'>' + '<h4 class=\'modal-title\'></h4>' + '</div>'
    footer: '<div class=\'modal-footer\'></div>'
    closeButton: '<button type=\'button\' class=\'bootbox-close-button close\' data-dismiss=\'modal\' aria-hidden=\'true\'>&times;</button>'
    form: '<form class=\'bootbox-form\'></form>'
    inputs:
      text: '<input class=\'bootbox-input bootbox-input-text form-control\' autocomplete=off type=text />'
      textarea: '<textarea class=\'bootbox-input bootbox-input-textarea form-control\'></textarea>'
      email: '<input class=\'bootbox-input bootbox-input-email form-control\' autocomplete=\'off\' type=\'email\' />'
      select: '<select class=\'bootbox-input bootbox-input-select form-control\'></select>'
      checkbox: '<div class=\'checkbox\'><label><input class=\'bootbox-input bootbox-input-checkbox\' type=\'checkbox\' /></label></div>'
      date: '<input class=\'bootbox-input bootbox-input-date form-control\' autocomplete=off type=\'date\' />'
      time: '<input class=\'bootbox-input bootbox-input-time form-control\' autocomplete=off type=\'time\' />'
      number: '<input class=\'bootbox-input bootbox-input-number form-control\' autocomplete=off type=\'number\' />'
      password: '<input class=\'bootbox-input bootbox-input-password form-control\' autocomplete=\'off\' type=\'password\' />'
  defaults =
    locale: 'en'
    backdrop: 'static'
    animate: true
    className: null
    closeButton: true
    show: true
    container: 'body'
  # our public object; augmented after our private API
  exports = {}

  exports.alert = ->
    options = undefined
    options = mergeDialogOptions('alert', [ 'ok' ], [
      'message'
      'callback'
    ], arguments)
    if options.callback and !$.isFunction(options.callback)
      throw new Error('alert requires callback property to be a function when provided')

    ###*
    # overrides
    ###

    options.buttons.ok.callback =
    options.onEscape = ->
      if $.isFunction(options.callback)
        return options.callback.call(this)
      true

    exports.dialog options

  exports.confirm = ->
    options = undefined
    options = mergeDialogOptions('confirm', [
      'cancel'
      'confirm'
    ], [
      'message'
      'callback'
    ], arguments)

    ###*
    # overrides; undo anything the user tried to set they shouldn't have
    ###

    options.buttons.cancel.callback =
    options.onEscape = ->
      options.callback.call this, false

    options.buttons.confirm.callback = ->
      options.callback.call this, true

    # confirm specific validation
    if !$.isFunction(options.callback)
      throw new Error('confirm requires a callback')
    exports.dialog options

  exports.prompt = ->
    `var defaults`
    options = undefined
    defaults = undefined
    dialog = undefined
    form = undefined
    input = undefined
    shouldShow = undefined
    inputOptions = undefined
    # we have to create our form first otherwise
    # its value is undefined when gearing up our options
    # @TODO this could be solved by allowing message to
    # be a function instead...
    form = $(templates.form)
    # prompt defaults are more complex than others in that
    # users can override more defaults
    # @TODO I don't like that prompt has to do a lot of heavy
    # lifting which mergeDialogOptions can *almost* support already
    # just because of 'value' and 'inputType' - can we refactor?
    defaults =
      className: 'bootbox-prompt'
      buttons: createLabels('cancel', 'confirm')
      value: ''
      inputType: 'text'
    options = validateButtons(mergeArguments(defaults, arguments, [
      'title'
      'callback'
    ]), [
      'cancel'
      'confirm'
    ])
    # capture the user's show value; we always set this to false before
    # spawning the dialog to give us a chance to attach some handlers to
    # it, but we need to make sure we respect a preference not to show it
    shouldShow = if options.show == undefined then true else options.show

    ###*
    # overrides; undo anything the user tried to set they shouldn't have
    ###

    options.message = form
    options.buttons.cancel.callback =
    options.onEscape = ->
      options.callback.call this, null

    options.buttons.confirm.callback = ->
      value = undefined
      switch options.inputType
        when 'text', 'textarea', 'email', 'select', 'date', 'time', 'number', 'password'
          value = input.val()
        when 'checkbox'
          checkedItems = input.find('input:checked')
          # we assume that checkboxes are always multiple,
          # hence we default to an empty array
          value = []
          each checkedItems, (_, item) ->
            value.push $(item).val()
            return
      options.callback.call this, value

    options.show = false
    # prompt specific validation
    if !options.title
      throw new Error('prompt requires a title')
    if !$.isFunction(options.callback)
      throw new Error('prompt requires a callback')
    if !templates.inputs[options.inputType]
      throw new Error('invalid prompt type')
    # create the input based on the supplied type
    input = $(templates.inputs[options.inputType])
    switch options.inputType
      when 'text', 'textarea', 'email', 'date', 'time', 'number', 'password'
        input.val options.value
      when 'select'
        groups = {}
        inputOptions = options.inputOptions or []
        if !$.isArray(inputOptions)
          throw new Error('Please pass an array of input options')
        if !inputOptions.length
          throw new Error('prompt with select requires options')
        each inputOptions, (_, option) ->
          # assume the element to attach to is the input...
          elem = input
          if option.value == undefined or option.text == undefined
            throw new Error('given options in wrong format')
          # ... but override that element if this option sits in a group
          if option.group
            # initialise group if necessary
            if !groups[option.group]
              groups[option.group] = $('<optgroup/>').attr('label', option.group)
            elem = groups[option.group]
          elem.append '<option value=\'' + option.value + '\'>' + option.text + '</option>'
          return
        each groups, (_, group) ->
          input.append group
          return
        # safe to set a select's value as per a normal input
        input.val options.value
      when 'checkbox'
        values = if $.isArray(options.value) then options.value else [ options.value ]
        inputOptions = options.inputOptions or []
        if !inputOptions.length
          throw new Error('prompt with checkbox requires options')
        if !inputOptions[0].value or !inputOptions[0].text
          throw new Error('given options in wrong format')
        # checkboxes have to nest within a containing element, so
        # they break the rules a bit and we end up re-assigning
        # our 'input' element to this container instead
        input = $('<div/>')
        each inputOptions, (_, option) ->
          checkbox = $(templates.inputs[options.inputType])
          checkbox.find('input').attr 'value', option.value
          checkbox.find('label').append option.text
          # we've ensured values is an array so we can always iterate over it
          each values, (_, value) ->
            if value == option.value
              checkbox.find('input').prop 'checked', true
            return
          input.append checkbox
          return
    # @TODO provide an attributes option instead
    # and simply map that as keys: vals
    if options.placeholder
      input.attr 'placeholder', options.placeholder
    if options.pattern
      input.attr 'pattern', options.pattern
    if options.maxlength
      input.attr 'maxlength', options.maxlength
    # now place it in our form
    form.append input
    form.on 'submit', (e) ->
      e.preventDefault()
      # Fix for SammyJS (or similar JS routing library) hijacking the form post.
      e.stopPropagation()
      # @TODO can we actually click *the* button object instead?
      # e.g. buttons.confirm.click() or similar
      dialog.find('.btn-primary').click()
      return
    dialog = exports.dialog(options)
    # clear the existing handler focusing the submit button...
    dialog.off 'shown.bs.modal'
    # ...and replace it with one focusing our input, if possible
    dialog.on 'shown.bs.modal', ->
      # need the closure here since input isn't
      # an object otherwise
      input.focus()
      return
    if shouldShow == true
      dialog.modal 'show'
    dialog

  exports.dialog = (options) ->
    options = sanitize(options)
    dialog = $(templates.dialog)
    innerDialog = dialog.find('.modal-dialog')
    body = dialog.find('.modal-body')
    buttons = options.buttons
    buttonStr = ''
    callbacks = onEscape: options.onEscape
    if $.fn.modal == undefined
      throw new Error('$.fn.modal is not defined; please double check you have included ' + 'the Bootstrap JavaScript library. See http://getbootstrap.com/javascript/ ' + 'for more details.')
    each buttons, (key, button) ->
      # @TODO I don't like this string appending to itself; bit dirty. Needs reworking
      # can we just build up button elements instead? slower but neater. Then button
      # can just become a template too
      buttonStr += '<button data-bb-handler=\'' + key + '\' type=\'button\' class=\'btn ' + button.className + '\'>' + button.label + '</button>'
      callbacks[key] = button.callback
      return
    body.find('.bootbox-body').html options.message
    if options.animate == true
      dialog.addClass 'fade'
    if options.className
      dialog.addClass options.className
    if options.size == 'large'
      innerDialog.addClass 'modal-lg'
    else if options.size == 'small'
      innerDialog.addClass 'modal-sm'
    if options.title
      body.before templates.header
    if options.closeButton
      closeButton = $(templates.closeButton)
      if options.title
        dialog.find('.modal-header').prepend closeButton
      else
        closeButton.css('margin-top', '-10px').prependTo body
    if options.title
      dialog.find('.modal-title').html options.title
    if buttonStr.length
      body.after templates.footer
      dialog.find('.modal-footer').html buttonStr

    ###*
    # Bootstrap event listeners; used handle extra
    # setup & teardown required after the underlying
    # modal has performed certain actions
    ###

    dialog.on 'hidden.bs.modal', (e) ->
      # ensure we don't accidentally intercept hidden events triggered
      # by children of the current dialog. We shouldn't anymore now BS
      # namespaces its events; but still worth doing
      if e.target == this
        dialog.remove()
      return

    ###
    dialog.on("show.bs.modal", function() {
      // sadly this doesn't work; show is called *just* before
      // the backdrop is added so we'd need a setTimeout hack or
      // otherwise... leaving in as would be nice
      if (options.backdrop) {
        dialog.next(".modal-backdrop").addClass("bootbox-backdrop");
      }
    });
    ###

    dialog.on 'shown.bs.modal', ->
      dialog.find('.btn-primary:first').focus()
      return

    ###*
    # Bootbox event listeners; experimental and may not last
    # just an attempt to decouple some behaviours from their
    # respective triggers
    ###

    if options.backdrop != 'static'
      # A boolean true/false according to the Bootstrap docs
      # should show a dialog the user can dismiss by clicking on
      # the background.
      # We always only ever pass static/false to the actual
      # $.modal function because with `true` we can't trap
      # this event (the .modal-backdrop swallows it)
      # However, we still want to sort of respect true
      # and invoke the escape mechanism instead
      dialog.on 'click.dismiss.bs.modal', (e) ->
        # @NOTE: the target varies in >= 3.3.x releases since the modal backdrop
        # moved *inside* the outer dialog rather than *alongside* it
        if dialog.children('.modal-backdrop').length
          e.currentTarget = dialog.children('.modal-backdrop').get(0)
        if e.target != e.currentTarget
          return
        dialog.trigger 'escape.close.bb'
        return
    dialog.on 'escape.close.bb', (e) ->
      if callbacks.onEscape
        processCallback e, dialog, callbacks.onEscape
      return

    ###*
    # Standard jQuery event listeners; used to handle user
    # interaction with our dialog
    ###

    dialog.on 'click', '.modal-footer button', (e) ->
      callbackKey = $(this).data('bb-handler')
      processCallback e, dialog, callbacks[callbackKey]
      return
    dialog.on 'click', '.bootbox-close-button', (e) ->
      # onEscape might be falsy but that's fine; the fact is
      # if the user has managed to click the close button we
      # have to close the dialog, callback or not
      processCallback e, dialog, callbacks.onEscape
      return
    dialog.on 'keyup', (e) ->
      if e.which == 27
        dialog.trigger 'escape.close.bb'
      return
    # the remainder of this method simply deals with adding our
    # dialogent to the DOM, augmenting it with Bootstrap's modal
    # functionality and then giving the resulting object back
    # to our caller
    $(options.container).append dialog
    dialog.modal
      backdrop: if options.backdrop then 'static' else false
      keyboard: false
      show: false
    if options.show
      dialog.modal 'show'
    # @TODO should we return the raw element here or should
    # we wrap it in an object on which we can expose some neater
    # methods, e.g. var d = bootbox.alert(); d.hide(); instead
    # of d.modal("hide");

    ###
     function BBDialog(elem) {
       this.elem = elem;
     }

     BBDialog.prototype = {
       hide: function() {
         return this.elem.modal("hide");
       },
       show: function() {
         return this.elem.modal("show");
       }
     };
    ###

    dialog

  exports.setDefaults = ->
    values = {}
    if arguments.length == 2
      # allow passing of single key/value...
      values[arguments[0]] = arguments[1]
    else
      # ... and as an object too
      values = arguments[0]
    $.extend defaults, values
    return

  exports.hideAll = ->
    $('.bootbox').modal 'hide'
    exports

  ###*
  # standard locales. Please add more according to ISO 639-1 standard. Multiple language variants are
  # unlikely to be required. If this gets too large it can be split out into separate JS files.
  ###

  locales =
    ar:
      OK: 'موافق'
      CANCEL: 'الغاء'
      CONFIRM: 'تأكيد'
    bg_BG:
      OK: 'Ок'
      CANCEL: 'Отказ'
      CONFIRM: 'Потвърждавам'
    br:
      OK: 'OK'
      CANCEL: 'Cancelar'
      CONFIRM: 'Sim'
    cs:
      OK: 'OK'
      CANCEL: 'Zrušit'
      CONFIRM: 'Potvrdit'
    da:
      OK: 'OK'
      CANCEL: 'Annuller'
      CONFIRM: 'Accepter'
    de:
      OK: 'OK'
      CANCEL: 'Abbrechen'
      CONFIRM: 'Akzeptieren'
    el:
      OK: 'Εντάξει'
      CANCEL: 'Ακύρωση'
      CONFIRM: 'Επιβεβαίωση'
    en:
      OK: 'OK'
      CANCEL: 'Cancel'
      CONFIRM: 'OK'
    es:
      OK: 'OK'
      CANCEL: 'Cancelar'
      CONFIRM: 'Aceptar'
    et:
      OK: 'OK'
      CANCEL: 'Katkesta'
      CONFIRM: 'OK'
    fa:
      OK: 'قبول'
      CANCEL: 'لغو'
      CONFIRM: 'تایید'
    fi:
      OK: 'OK'
      CANCEL: 'Peruuta'
      CONFIRM: 'OK'
    fr:
      OK: 'OK'
      CANCEL: 'Annuler'
      CONFIRM: 'Confirmer'
    he:
      OK: 'אישור'
      CANCEL: 'ביטול'
      CONFIRM: 'אישור'
    hu:
      OK: 'OK'
      CANCEL: 'Mégsem'
      CONFIRM: 'Megerősít'
    hr:
      OK: 'OK'
      CANCEL: 'Odustani'
      CONFIRM: 'Potvrdi'
    id:
      OK: 'OK'
      CANCEL: 'Batal'
      CONFIRM: 'OK'
    it:
      OK: 'OK'
      CANCEL: 'Annulla'
      CONFIRM: 'Conferma'
    ja:
      OK: 'OK'
      CANCEL: 'キャンセル'
      CONFIRM: '確認'
    lt:
      OK: 'Gerai'
      CANCEL: 'Atšaukti'
      CONFIRM: 'Patvirtinti'
    lv:
      OK: 'Labi'
      CANCEL: 'Atcelt'
      CONFIRM: 'Apstiprināt'
    nl:
      OK: 'OK'
      CANCEL: 'Annuleren'
      CONFIRM: 'Accepteren'
    no:
      OK: 'OK'
      CANCEL: 'Avbryt'
      CONFIRM: 'OK'
    pl:
      OK: 'OK'
      CANCEL: 'Anuluj'
      CONFIRM: 'Potwierdź'
    pt:
      OK: 'OK'
      CANCEL: 'Cancelar'
      CONFIRM: 'Confirmar'
    ru:
      OK: 'OK'
      CANCEL: 'Отмена'
      CONFIRM: 'Применить'
    sq:
      OK: 'OK'
      CANCEL: 'Anulo'
      CONFIRM: 'Prano'
    sv:
      OK: 'OK'
      CANCEL: 'Avbryt'
      CONFIRM: 'OK'
    th:
      OK: 'ตกลง'
      CANCEL: 'ยกเลิก'
      CONFIRM: 'ยืนยัน'
    tr:
      OK: 'Tamam'
      CANCEL: 'İptal'
      CONFIRM: 'Onayla'
    zh_CN:
      OK: 'OK'
      CANCEL: '取消'
      CONFIRM: '确认'
    zh_TW:
      OK: 'OK'
      CANCEL: '取消'
      CONFIRM: '確認'

  exports.addLocale = (name, values) ->
    $.each [
      'OK'
      'CANCEL'
      'CONFIRM'
    ], (_, v) ->
      if !values[v]
        throw new Error('Please supply a translation for \'' + v + '\'')
      return
    locales[name] =
      OK: values.OK
      CANCEL: values.CANCEL
      CONFIRM: values.CONFIRM
    exports

  exports.removeLocale = (name) ->
    delete locales[name]
    exports

  exports.setLocale = (name) ->
    exports.setDefaults 'locale', name

  exports.init = (_$) ->
    init _$ or $

  exports
