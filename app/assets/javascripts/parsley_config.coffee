class ParsleyConfigurator
  @configure: (selector) ->
    forms = $(selector)
    if forms.length
      forms.parsley
        errorClass: 'form-control-danger'
        successClass: 'form-control-success'
        errorsContainer: (field) ->
          $firstFormGroup = field.$element.parents('.form-group')
          $children = $firstFormGroup.find('.form-control-feedback')
          if $children.length > 0
            return $children
          else
            return $firstFormGroup.parents('.form-group').find('.form-control-feedback')


document.addEventListener 'turbolinks:request-end', ->
  ParsleyConfigurator.configure '.modal form'

document.addEventListener 'turbolinks:load', ->
  ParsleyConfigurator.configure 'form'

  window.Parsley.on 'field:validated', () ->
    this.$element.parents('.form-group').toggleClass 'has-danger', !this.isValid()
    # console.log(this)

window.ParsleyConfigurator = ParsleyConfigurator
