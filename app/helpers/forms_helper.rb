# frozen_string_literal: true
module FormsHelper
  def number_input(builder, attribute, label = nil, params = {})
    __input :number_field, builder, attribute, label, params
  end

  def text_input(builder, attribute, label = nil, params = {})
    __input :text_field, builder, attribute, label, params
  end

  def textarea_input(builder, attribute, label = nil, params = {})
    add_class_to_options(params, 'form-control')
    params[:autocomplete] ||= 'off'

    capture do
      concat(
        content_tag(:div, class: 'form-group mb-025') do
          concat text_area_label(builder, attribute, label)
          concat text_area_element(builder, attribute, params)
          concat parsley_errors_element
        end
      )
    end
  end

  private

  def __input(input_type, builder, attribute, label, params)
    add_class_to_options(params, 'form-control')
    params[:autocomplete] ||= 'off'

    capture do
      concat(
        content_tag(:div, class: 'form-group mb-025 ' + dom_class(builder.object, attribute)) do
          concat input_element(input_type, builder, attribute, label, params)
          concat parsley_errors_element
        end
      )
    end
  end

  def parsley_errors_element
    content_tag(:div, class: 'row') do
      content_tag(:div, '', class: 'col-xs-12 offset-md-1 form-control-feedback')
    end
  end

  def text_area_label(builder, attribute, label)
    content_tag(:div, class: 'row') do
      concat(builder.label(attribute, label, class: 'col-xs-10 offset-xs-1'))
    end
  end

  def text_area_element(builder, attribute, params)
    content_tag(:div, class: 'row') do
      concat(content_tag(:div, class: 'col-xs-10 offset-xs-1') do
        builder.text_area attribute, params
      end)
    end
  end

  def input_element(input_type, builder, attribute, label, params)
    content_tag(:div, class: 'row') do
      concat(builder.label(attribute, label, class: 'col-xs-5 offset-xs-1'))
      concat(content_tag(:div, class: 'col-xs-5') do
        concat(builder.send(input_type, attribute, params))
      end)
    end
  end
end
