# frozen_string_literal: true
require 'stringio'

module ProcessDiagram
  class Pdf
    include Prawn::View
    include ::Encryption
    attr_accessor :process_flow
    def initialize(process_flow)
      @process_flow = process_flow
      font Sop::Constants::COURIER_NEW
      write_doc
      encrypt(self)
    end

    private

    def write_doc
      write_header
      faded_hrule
      move_down 8
      add_image_to_pdf
      move_down 3
      faded_hrule
      move_down 3
      font_size 10
      text 'Copyright 2016 Manufacturing LLC. All rights reserved.' + "\n" \
        ' Proprietary and confidential.  Do not duplicate or distribute.', color: 'afafaf'
    end

    def write_header
      write_title
      current_cursor = cursor
      write_category
      write_product
      move_cursor_to current_cursor
      write_version_number
      write_last_modified
    end

    def write_title
      a = cursor
      text process_flow.title, size: 18, align: :left
      move_cursor_to a
      text "Process Flow #{process_flow.document_id}", size: 18, align: :right
    end

    delegate :category, :product, :to_png, to: :process_flow

    def write_version_number
      text "Version #{process_flow.version}", size: 14, align: :right
    end

    def write_last_modified
      text "Updated #{process_flow.updated_at.strftime('%m/%d/%Y')}", size: 14, align: :right
    end

    def write_category
      return if category.blank?
      text "Category - #{category}", size: 14
    end

    def write_product
      return if product.blank?
      text "Product  - #{product}", size: 14
    end

    def add_image_to_pdf
      image StringIO.new(to_png), height: cursor - 30, position: :center
    end

    def faded_hrule
      stroke_color 'afafaf'
      stroke_horizontal_rule
    end
  end
end
