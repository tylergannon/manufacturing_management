# frozen_string_literal: true
module BatchesHelper
  def print_message_wrapper(batch)
    return {} unless batch.can_print_labels?
    {
      title: batch.labels_error_message,
      'data-toggle': 'tooltip',
      'data-trigger': 'hover'
    }
  end

  def carton_labels_link(batch)
    _labels_tag(url_for([batch, :carton_labels, {format: :pdf}]), batch)
  end

  def box_labels_link(batch)
    _labels_tag(url_for([batch, :box_labels, {format: :pdf}]), batch)
  end

  private

  def _labels_tag(link_href, batch)
    tag = {
      tag: 'a',
      href: link_href,
      target: '_blank',
      class: 'btn btn-secondary hidden-sm-down'
    }
    tag[:class] += ' disabled' unless batch.can_print_labels?
    tag
  end
end
