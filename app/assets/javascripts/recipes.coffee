# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
tl_load ->
  $('.recipe input#recipe_primary_ingredient_quantity').on 'keyup', ->
    primary_ingredient_quantity = parseFloat(this.value)
    return unless primary_ingredient_quantity > 0
    $('.recipe_ingredient').each (i, row) ->
      $row = $(row)
      grams_per_kilo = parseFloat($row.data('grams-per-kilo'))
      grams_needed   = grams_per_kilo * primary_ingredient_quantity
      if grams_needed > 10
        grams_needed = Math.round(grams_needed + 0.5)
      else
        grams_needed = Math.round(grams_needed * 100) / 100

      if grams_needed > 1000
        $row.find('.quantity').html((grams_needed/1000).toString() + ' kg')
      else
        $row.find('.quantity').html((grams_needed).toString() + ' g')

  $('#update_recipe_quanties').on 'click', (e) ->
    e.preventDefault()
    $this = $(e.target)
    url = $this.data('url')
    multiplier = $('#multiplier').val()
    primary_ingredient_quantity = $('#primary_ingredient_quantity').val()
    Turbolinks.visit url + '?primary_ingredient_quantity=' + primary_ingredient_quantity + '&multiplier=' + multiplier
    return false

  $(document).on 'click', 'a.sortable', (e) ->
    e.preventDefault()
    $a = $(this)
    $list_item = $a.closest('li.list-group-item')
    if $a.is('.down')
      $list_item.next('li.list-group-item').after $list_item
    else
      console.log('up')
      console.log($list_item)
      $list_item.prev('li.list-group-item').before $list_item
    order = $.map $('#recipe_list').children(), (obj) -> $(obj).data('id')
    $.ajax
      type: 'POST'
      url: $('#recipe_list').data('url')
      data:
        order:
          order

    return


  # $('#recipe_list')
  #   containerSelector: 'div.recipe_list'
  #   handle: 'i'
  #   itemSelector: 'a.list-group-item'
  #
  #   onDrop: ($item, container, _super) ->
  #     $table = $('#recipe_list')
  #     console.log $table.sortable('serialize').get()[0]
  #     $.ajax
  #       type: 'POST'
  #       url: $table.data('url')
  #       data:
  #         order:
  #           $table.sortable('serialize').get()[0]
  #     _super($item, container)
