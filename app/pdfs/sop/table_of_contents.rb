# frozen_string_literal: true
module Sop
  module TableOfContents
    include Constants

    MAX_HEADER_LEVEL = 2

    TOC_TITLE_FONT_CONFIG = ['Helvetica', { size: 20 }].freeze
    TOC_FONT_CONFIG = [COURIER_NEW, {
      size: 14
    }].freeze

    attr_accessor :toc_page_number

    # Create a blank page where the table of contents will be written.
    def setup_document(_)
      pdf = super
      @toc_page_number = pdf.outline.page_number
      pdf.start_new_page
      pdf
    end

    # Write the table of contents
    def finish_document(_root)
      super
      draw_table_of_contents(on_page: toc_page_number)
    end

    def render_header(el, opts)
      super
      add_header_to_toc(el)
    end

    private

    def draw_table_of_contents(on_page:)
      goto_toc_position(on_page)
      write_title
      # binding.pry
      write_toc_items
    end

    def build_toc_header(el)
      header = {
        page: @pdf.outline.page_number,
        title: el.children.first.value,
        level: el.options[:level]
      }
      header[:anchor] = header[:title].parameterize
      header
    end

    def add_header_to_toc(el)
      header = build_toc_header(el)
      table_of_contents << header
      @pdf.instance_exec(header) do |h|
        add_dest h[:anchor], dest_xyz(bounds.absolute_left, y)
      end
    end

    def table_of_contents
      @table_of_contents ||= []
    end

    def goto_toc_position(page)
      @pdf.instance_exec(outline) do |_outline|
        go_to_page page
        move_cursor_to 600
      end
    end

    def write_title
      @pdf.instance_exec(metadata.title, metadata.document_id) do |title, document_id|
        font(*TOC_TITLE_FONT_CONFIG) do
          text "#{document_id}: #{title}", align: :center
          move_down 10
          text 'Table Of Contents', align: :center
        end
      end
    end

    def headers_to_show
      table_of_contents.select { |header| header[:level] <= MAX_HEADER_LEVEL }
    end

    def toc_line_size
      lengths = headers_to_show.map do |header|
        (indented_title(header) + effective_page(header)).length
      end
      lengths.max + 2
    end

    def effective_page(header)
      (header[:page] - 1).to_s
    end

    def write_toc_items
      @pdf.move_down 10
      headers_to_show.each do |header|
        write_toc_item header
      end
    end

    INDENT_CHAR = '• '
    INDENT_SIZE = 1

    def indented_title(header)
      (INDENT_CHAR * INDENT_SIZE * (header[:level] - 1)) + header[:title]
    end

    def toc_line(header, with_link = false)
      title = indented_title(header)
      page_number = effective_page(header)
      dots = '.' * (toc_line_size - page_number.length - title.length)
      if with_link
        "<link anchor='#{header[:anchor]}'>#{title + dots + page_number}</link>"
      else
        title + dots + page_number
      end
    end

    def write_toc_item(header)
      @pdf.font(*TOC_FONT_CONFIG) do
        @pdf.text toc_line(header, true), align: :center, inline_format: true
      end
    end
  end
end
