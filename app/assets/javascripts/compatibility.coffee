unless Turbolinks.supported
  window.addEventListener 'load', ->
    Turbolinks.dispatch('turbolinks:load')
