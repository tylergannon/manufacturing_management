if typeof Function::bind == 'undefined'

  Function::bind = (target) ->
    f = this
    ->
      f.apply target, arguments
