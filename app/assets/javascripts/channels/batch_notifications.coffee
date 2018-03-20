# App.batch_notifications = App.cable.subscriptions.create "BatchNotificationsChannel",
#   connected: ->
#     console.log "Batch Notifications Connected"
#     # Called when the subscription is ready for use on the server
#
#   disconnected: ->
#     # Called when the subscription has been terminated by the server
#
#   received: (data) ->
#     console.log(data)
#     switch data.type
#       when "event_occurred"
#         $('#event_button').replaceWith(data.button)
#       when "feedback_form"
#         Alerts.modal "form_modal",
#           form_controls: (new Handlebars.SafeString(data.form_controls))
#
#       when "request_confirmation"
#         Alerts.batchConfirmationAlert data.batch_number, data.requested_by
#       when "confirmed"
#         Alerts.batchConfirmedAlert data.batch_number, data.requested_by
#
#   sendMessage: (messageBody) ->
#     this.perform 'send_message',
#       body: messageBody
#
#   onBatchWorkflowEvent: (batchId, eventName, params = {}) ->
#     this.perform 'batch_workflow_event',
#       event: eventName
#       batch_id: batchId
#       params: params
#
#   getFeedbackForm: (batchId, eventName) ->
#     this.perform 'get_feedback_form',
#       event: eventName
#       batch_id: batchId
