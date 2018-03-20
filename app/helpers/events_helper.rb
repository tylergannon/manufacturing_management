# frozen_string_literal: true
module EventsHelper
  def event_link_attrs(batch, event)
    event_id = event.name
    url = batch_event_path(batch, event_id)
    attrs = {
      class: "btn btn-#{event.bs_class}",
      data: {
        turbolinks: false,
        remote: true,
        'event-id': event_id
      }
    }

    attrs[:method] = 'patch' unless event.feedback?

    [url, attrs]
  end

  def event_form_button(_batch, event)
    {
      tag: 'button',
      type: 'submit',
      class: "btn btn-#{event.bs_class}"
    }
  end
end
