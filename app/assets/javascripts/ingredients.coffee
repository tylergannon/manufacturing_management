# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

tl_load ->
  $('#ingredients-plan-days').on 'change', (e) ->
    Turbolinks.visit('/ingredients/plan?days=' + e.target.value.toString())
