# frozen_string_literal: true
module ShipmentsHelper
  def friendly_date(d)
    return nil unless d
    if d.year != Date.today.year
      d.strftime('%b %-d, %Y')
    else
      d.strftime('%b %-d')
    end
  end

  def active_link(name)
    name == @active_link ? { class: 'active' } : {}
  end

  def active_state(name)
    name == @active_state ? { class: 'active' } : {}
  end

  def shipment_event_link(shipment, event, return_to = nil, &block)
    disabled = (' disabled' if cannot?(event, shipment))
    link_params = {
      shipment: { a: :b }
    }

    link_params[:return_to] = return_to if return_to

    link_to shipment_event_path(shipment, event, link_params),
            class: "btn btn-lg px-3 btn-primary#{disabled}",
            method: 'POST',
            'data-turbolinks' => 'false',
            remote: false, &block
  end

  def shipment_prep_input(attribute, f, label = nil, as: :string, width: 'col-xs-6')
    capture do
      content_tag(:div, class: "#{width} form-group optional #{attribute}") do
        concat shipment_input_label(label, attribute)
        concat(f.input_field(attribute, as: as, class: 'form-control'))
        yield if block_given?
      end
    end
  end

  private

  def shipment_input_label(label, attribute)
    icon_class = @shipment.send(attribute).present? ? 'fa-check-square-o' : 'fa-square-o'
    content_tag('label', class: 'col-form-label') do
      concat(content_tag('i', '', class: "fa mr-1-sm-up #{icon_class}"))
      concat(content_tag('span', (label || attribute.to_s.titleize)))
    end
  end
end
