class Notes
  @transitionDuration: 1000

  @closeModal: ->
    $('#add-notes-modal').modal('hide')
  @resetForm: ->
    $('#add-notes-modal textarea').value = ''
  @addNote: (html) ->
    new_node = @_createAsHidden(html)
    $('#notes_container').prepend(new_node)
    new_node.slideDown @transitionDuration, =>
      @flash(new_node)
  @removeNote: (dom_id) ->
    node = $('#' + dom_id)
    @flash(node)
    node.fadeOut
      duration: @transitionDuration
      queue: false
    node.slideUp
      duration: @transitionDuration
      queue: false
      # $(selector).remove()
  @editNote: (dom_id, html) ->
    new_node = @_createAsHidden(html)
    old_node = $('#' + dom_id)
    @replaceNode old_node, new_node, -> new_node.find('textarea').focus()
  @updateNote: (dom_id, html) ->
    new_node = @_createAsHidden(html)
    @replaceNode $('#edit_' + dom_id), new_node
  @cancelEdit: (dom_id, html) ->
    old_node = $('#edit_' + dom_id)
    new_node = @_createAsHidden(html)
    @replaceNode old_node, new_node

  @replaceNode: (old_node, new_node, cb) ->
    new_node.insertBefore(old_node)
    old_node.slideUp
      duration: @transitionDuration
      queue: false
      complete: -> old_node.remove()
    new_node.slideDown
      duration: @transitionDuration
      queue: false
      complete: =>
        @flash(new_node)
        cb() if cb?

  @flash: ($node) ->
    $title = $node.find('.card-block')
    $title.css('transition', 'border-color 1.5s ease, border-width 1.5s ease')
    $title.addClass('flash-transition')
    setTimeout (-> $title.removeClass('flash-transition')), 5000
  @_createAsHidden: (html) ->
    new_node = $(html)
    new_node.hide()
    new_node
window.Notes = Notes

document.addEventListener 'turbolinks:load', ->
  $(document).on 'shown.bs.modal', '#add-notes-modal', ->
    $('#add-notes-modal textarea').focus()
