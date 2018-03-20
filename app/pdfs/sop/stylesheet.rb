# frozen_string_literal: true
module Sop
  module Stylesheet
    extend ActiveSupport::Concern
    include PdfStylesheet
    include Constants

    PAGE_BREAK_RULES = [nil, 600, 200, 200, 100, 100].freeze

    MARGIN_TOP_MM    = 25
    MARGIN_BOTTOM_MM = 30
    MARGIN_LEFT_MM   = 25
    MARGIN_RIGHT_MM  = 25

    included do
      style :document do
        margin 0
        top_margin mm2pt(MARGIN_TOP_MM)
        bottom_margin mm2pt(MARGIN_BOTTOM_MM)
        left_margin mm2pt(MARGIN_LEFT_MM)
        right_margin mm2pt(MARGIN_RIGHT_MM)
      end

      style :root do
        font COURIER_NEW
      end

      style :header1 do
        bottom_padding(-10)
        top_padding 0
      end

      style :header2 do
        size 20
        bottom_padding 5
      end

      style :strong do
        font COURIER_BOLD
      end

      style :em do
        font COURIER_ITALIC
      end

      style :header3 do
        size 15
        styles [:bold]
        font COURIER_NEW
        top_padding 0
        bottom_padding 0
      end
    end

    def document_options(_)
      super.merge(info: metadata.pdf_metadata)
    end

    def render_header(el, opts)
      page_break_unless_near_top_of_page(el)
      super
      return unless el.options[:level] == 1

      @pdf.stroke_horizontal_rule
      @pdf.move_down 12
    end

    def render_page_break(*_)
      @pdf.start_new_page
    end

    def page_break_options(*_)
      {}
    end

    private

    def page_break_unless_near_top_of_page(el)
      @pdf.start_new_page if @pdf.cursor < PAGE_BREAK_RULES[el.options[:level]]
    end
  end
end
