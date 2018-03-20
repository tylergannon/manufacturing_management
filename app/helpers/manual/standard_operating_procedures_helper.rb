# frozen_string_literal: true
module Manual
  module StandardOperatingProceduresHelper
    def link_to_sop(sop, *args)
      link_title = "#{sop.document_id} #{sop.title}"
      link_to(link_title, sop)
    end

    def default_editor_theme
      DEFAULT_EDITOR_THEME
    end

    def default_editor_font_size
      DEFAULT_EDITOR_FONT_SIZE
    end

    def editor_themes
      EDITOR_THEMES
    end

    DEFAULT_EDITOR_FONT_SIZE = 16
    DEFAULT_EDITOR_THEME = 'dreamweaver'
    EDITOR_THEMES = %w(chaos
                       cobalt
                       dreamweaver).freeze
  end
end
