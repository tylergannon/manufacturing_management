# frozen_string_literal: true
module BootstrapHtmlHelper
  def vertical_form_for(record, options = {}, &block)
    options[:builder] = VerticalFormBuilder
    form_for record, options, &block
  end

  def list_group
    capture do
      content_tag(:ul, class: 'list-group') { yield }
    end
  end

  def icon_button(text, icon)
    capture do
      concat(content_tag('i', '', class: "mr-1-sm-up fa #{icon}"))
      concat(content_tag('span', text, class: 'hidden-xs-down'))
    end
  end

  def tooltip(title, trigger: 'hover', placement: 'top')
    {
      'data-toggle': 'tooltip',
      'data-trigger': trigger,
      'data-placement': placement,
      title: title
    }
  end

  def list_group_item(model)
    id = model.is_a?(ApplicationRecord) ? dom_id(model) : "#{model}-list-group-item"
    concat(content_tag(:li, class: 'list-group-item', id: id) { yield(model) })
  end

  def list_group_items(collection, &block)
    capture do
      collection.each do |model|
        list_group_item(model, &block)
      end
    end
  end

  def list_group_item_header(content = nil, tag: :h4, html: {})
    html[:class] = [html[:class], 'list-group-item-header'].reject(&:nil?).join(' ')

    capture do
      concat content_tag(tag, content, html)
    end
  end

  def horizontal_dl(cssClass: nil, &block)
    content_tag(:dl, class: "#{cssClass} row", &block)
  end

  def dl_attributes(model, *attributes)
    capture do
      attributes.each do |attribute|
        value = model.send(attribute)
        value = friendly_date(value) if value.is_a? Date
        concat dl_item model.class.human_attribute_name(attribute), value
      end
    end
  end

  DT_ITEM_CLASS = 'col-xs-5 col-sm-4 col-md-3 text-truncate'

  def dl_item(term, description = nil)
    capture do
      concat content_tag(:dt, term, class: DT_ITEM_CLASS, 'data-name' => term)
      if block_given?
        concat content_tag(:dd, class: 'col-xs-7 text-truncate') { yield }
      else
        concat content_tag(:dd, (description || 'N/A'), class: 'col-xs-7 text-truncate')
      end
    end
  end

  def pill(primary = nil, secondary: nil, pull: 'left', size: 'xs', tag: 'primary')
    capture do
      concat(
        content_tag(:span, class: "tag tag-#{tag} tag-pill pull-#{size}-#{pull}") do
          if block_given?
            yield
          else
            concat content_tag(:span, primary)
            concat content_tag(:span, secondary, class: 'add-space-left') if secondary
          end
        end
      )
    end
  end
end
