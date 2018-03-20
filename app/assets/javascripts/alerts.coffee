$.fn.twitter_bootstrap_confirmbox.defaults.title = "Are you sure?"

class Alerts
  @dropFlash: ->
    $('.alert').remove()

  @flash: (message, type = 'success') ->
    $('#alerts').html HandlebarsTemplates['alert']
        message: message
        alert_class: @bootstrap_class_for(type)
    @showFlash()

  @CLASSES:
    success: 'alert-success'
    error: 'alert-danger'
    alert: 'alert-warning'
    notice: 'alert-info'

  @bootstrap_class_for: (type) ->
    @CLASSES[type]

  # def bootstrap_class_for(flash_type)
  #   FLASH_CLASSES[flash_type] || flash_type.to_s
  # end


  @showFlash: ->
    $('.alert').show()
    setTimeout (->
      $('.alert').slideUp()
    ), 5000

  @modalAlert: (message, cssClass = 'success') ->
    $('body').append(
      HandlebarsTemplates['modal_alert']
        modalTitle: 'Notication'
        message: message
    )
    $('#bs-alert-modal').on 'hidden.bs.modal', (e) ->
      $(e.target).remove()

    $('#bs-alert-modal').modal()

  @batchConfirmationAlert: (batch_number, requested_by) ->
    $('body').append(
      HandlebarsTemplates['batch_confirmation_alert']
        batch_number: batch_number
        requested_by: requested_by
    )
    $('#batch-confirmation-alert').on 'hidden.bs.modal', (e) ->
      $(e.target).remove()

    $('#batch-confirmation-alert').modal()

  @batchConfirmedAlert: (batch_number, requested_by) ->
    $('body').append(
      HandlebarsTemplates['batch_confirmed_alert']
        batch_number: batch_number
        requested_by: requested_by
    )
    $('#batch-confirmed-alert').on 'hidden.bs.modal', (e) ->
      $(e.target).remove()

    $('#batch-confirmed-alert').modal()

  @modal: (name, data) ->
    console.log(data)
    $('body').append(
      HandlebarsTemplates[name](data)
    )
    $('#' + name).on 'hidden.bs.modal', (e) ->
      $(e.target).remove()

    $('#' + name).modal()



window.Alerts = Alerts
