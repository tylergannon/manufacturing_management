
window.puts = (str) ->
  console.log(str)

window.tl_load = (fn) ->
  $(document).on 'turbolinks:load', fn

document.addEventListener 'turbolinks:before-cache', ->
  Alerts.dropFlash()

document.addEventListener 'turbolinks:load', (e) ->
  Alerts.showFlash()

  $('[data-toggle="tooltip"]').tooltip()
  $('[data-click="modal"]').on 'click', (e) ->
    $(e.currentTarget.dataset.target).modal('show')

  $(document).on 'click', '.linkable', (e) ->
    Turbolinks.visit this.dataset.href
  $('.modal.show-immediately').modal('show')
