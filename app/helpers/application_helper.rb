# frozen_string_literal: true
module ApplicationHelper
  def add_class_to_options(options, css_class)
    if options.key? :class
      options[:class] += " #{css_class}"
    else
      options[:class] = css_class
    end
  end

  def table_row
    { tag: 'div', class: 'row mx-0-sm-up py-1-sm-up' }
  end

  def responsive_btn_text(icon, text)
    capture do
      concat(content_tag(:i, '', class: "fa fa-#{icon} mr-1-sm-up"))
      concat(content_tag(:span, text, class: 'hidden-xs-down'))
    end
  end

  def icon_btn_text(icon, text)
    capture do
      concat(content_tag(:i, '', class: "fa fa-#{icon} mr-1"))
      concat(content_tag(:span, text))
    end
  end

  def dom_ids(*models, label: nil)
    label.to_s + models.collect { |t| dom_id(t) }.join('-')
  end

  def dropdown_toggle_link
    {
      'class'         => 'nav-link dropdown-toggle active',
      'data-toggle'   => 'dropdown',
      'href'          => '#',
      'role'          => 'button',
      'aria-haspopup' => 'true',
      'aria-expanded' => 'false'
    }
  end

  FLASH_CLASSES = {
    success: 'alert-success',
    error: 'alert-danger',
    alert: 'alert-warning',
    notice: 'alert-info'
  }.freeze

  def bootstrap_class_for(flash_type)
    FLASH_CLASSES[flash_type] || flash_type.to_s
  end
end
