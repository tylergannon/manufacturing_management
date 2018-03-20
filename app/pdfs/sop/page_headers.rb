
# frozen_string_literal: true
module Sop
  module PageHeaders
    include Constants
    def outline
      @outline ||= [{ title: 'Table Of Contents', page: 2 }]
    end

    def render_header(el, opts)
      super
      return unless el.options[:level] == 1
      add_header_to_outline(el)
    end

    def finish_document(_root)
      super

      write_page_headers
    end

    private

    def write_page_headers
      add_page_ranges_to_outline
      @pdf.extend PdfDocumentHeader
      outline.each do |header|
        page_headers_for_range(header)
      end
    end

    HEADER_COLOR = 'afafaf'

    def add_page_ranges_to_outline
      outline.each_with_index do |header, i|
        header[:pages] = header[:page]..page_prior_to_header(i)
      end
    end

    def page_prior_to_header(index)
      -1 + (outline[index + 1]&.fetch(:page) || 1_000_000)
    end

    def page_headers_for_range(h)
      @pdf.repeat(h[:pages]) do
        @pdf.write_page_header(metadata.title, h[:title], metadata.document_id, COURIER_NEW)
      end

      @pdf.instance_exec(h, metadata, COURIER_NEW) do |header, _metadata, _font_name|
        repeat(header[:pages]) do
        end
      end
    end

    module PdfDocumentHeader
      def write_page_header(title, section, doc_id, font_name)
        font font_name do
          move_cursor_to bounds.top + 38
          text "Section: #{section}", align: :right, color: HEADER_COLOR
          move_cursor_to bounds.top + 38
          text "#{doc_id}: #{title}", color: HEADER_COLOR
          stroke_color 'cccccc'
          stroke_horizontal_rule
        end
      end
    end

    def add_header_to_outline(el)
      outline << { page: @pdf.outline.page_number, title: el.children.first.value }
    end
  end
end
