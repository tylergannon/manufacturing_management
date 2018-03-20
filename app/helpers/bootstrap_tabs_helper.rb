# frozen_string_literal: true
module BootstrapTabsHelper
  def tab_pane(id, active = true, &block)
    active = active ? ' active' : ''
    capture do
      concat(
        content_tag(:div, class: 'card tab-pane p-1' + active, id: id, role: 'tabpanel', &block)
      )
    end
  end

  def tab_content(&block)
    capture { content_tag(:div, class: 'tab-content', &block) }
  end

  def icon_tab(icon, id, active: nil, size: 'xs', action: nil)
    active_class = id == active ? ' active' : ''
    capture do
      concat(
        content_tag(:li, class: 'nav-item') do
          content_tag(:a, href: url_for([action || id, @batch]),
                          class: 'nav-link' + active_class,
                          role: 'tab') do
            concat content_tag(:i, '', class: "fa #{icon}")
            concat content_tag(:span, id.titleize, class: "hidden-#{size}-down ml-05-sm-up")
          end
        end
      )
    end
  end

  def nav_tabs(&block)
    capture do
      content_tag(:ul, class: 'nav nav-tabs', role: 'tablist', &block)
    end
  end

  def nav_tab(title, id, active: false)
    capture do
      concat(
        content_tag(:li,
                    content_tag(:a, title, href: "##{id}",
                                           class: 'nav-link' + (active ? ' active' : ''),
                                           'data-toggle' => 'tab',
                                           role: 'tab'),
                    class: 'nav-item')
      )
    end
  end
end
