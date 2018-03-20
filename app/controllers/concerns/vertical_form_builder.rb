# frozen_string_literal: true
class VerticalFormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::CaptureHelper
  include ActionView::Helpers::TextHelper

  attr_accessor :output_buffer

  def text_input(attribute, options = {})
    add_form_control_class options
    add_placeholder attribute, options

    content_tag :div, class: 'form-group' do
      concat(label(attribute)) if label?(options)
      concat text_field(attribute, options)
    end
  end

  def text_area_input(attribute, options = {})
    add_form_control_class options
    add_placeholder attribute, options

    content_tag :div, class: 'form-group' do
      concat(label(attribute)) if label?(options)
      concat text_area(attribute, options)
    end
  end

  def password_input(attribute, options = {})
    add_form_control_class options
    add_placeholder attribute, options

    content_tag :div, class: 'form-group' do
      concat(label(attribute)) if label?(options)
      concat password_field(attribute, options)
    end
  end

  def submit_button(value, icon: nil, btn_style: 'btn-primary', btn_size: nil, **options)
    add_class_to_options options, "btn #{btn_style}"
    add_class_to_options options, btn_size unless btn_size.blank?

    content_tag :button, options.merge(type: 'submit', value: value) do
      if icon
        concat content_tag(:i, '', class: "fa fa-#{icon} pr-1 pull-xs-left")
      end
      concat value
    end
  end

  private

  def add_class_to_options(options, css_class)
    if options.key? :class
      options[:class] += " #{css_class}"
    else
      options[:class] = css_class
    end
  end

  def label?(options)
    if options.key? :label
      options.delete(:label)
    else
      true
    end
  end

  def add_placeholder(attribute, options)
    return unless options.key? :placeholder

    i18n_key = "forms.placeholders.#{object.class.name.underscore}.#{attribute}"
    options[:placeholder] = I18n.t(i18n_key) if I18n.exists? i18n_key
  end

  def add_form_control_class(options)
    if options.key? :class
      options[:class] += ' form-control'
    else
      options[:class] = 'form-control'
    end
  end
end
