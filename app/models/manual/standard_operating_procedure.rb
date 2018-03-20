# frozen_string_literal: true
require 'English'

module Manual
  class StandardOperatingProcedure < ApplicationRecord
    include ManualDocumentWorkflow
    extend FriendlyId
    friendly_id :title, use: :slugged

    has_many :change_logs, class_name: 'Manual::ChangeLog', as: :document

    accepts_nested_attributes_for :change_logs

    def to_html
      Kramdown::Document.new(body).to_html
    end

    def filename
      "#{document_id} - #{title} v#{version}.pdf"
    end

    alias_method :output_filename, :filename

    def to_pdf(**document_options)
      kramdown_document(**document_options).to_pdf
    end

    def kramdown_document(**options)
      @doc ||= KramdownDocument.new(body, metadata: header_data, **options)
    end

    def document_id
      "SOP#{process_id || id}"
    end

    def todo_list
      todo_items = lines.enum_for(:each_with_index).map do |line, line_number|
        TodoItem.parse(line, at: line_number + 1)
      end
      todo_items.compact
    end

    def lines
      body.split("\n")
    end

    private

    class TodoItem
      attr_accessor :line_number, :text
      def initialize(text, line_number)
        @text = text
        @line_number = line_number
      end

      SELECTOR = /TODO: (.*)$/

      def self.parse(text, at: nil)
        return unless text =~ /TODO: (.*)$/
        new($LAST_MATCH_INFO[1].strip, at)
      end
    end

    def header_data
      Hashie::Mash.new(document_id: document_id,
                       author: author.name,
                       title: title,
                       updated_at: updated_at.strftime('%m/%d/%Y'),
                       version: version,
                       pdf_metadata: {
                         Title: "Manufacturing SOP #{document_id}: #{title}",
                         Author: author.name,
                         Copyright: copyright,
                         Subject: 'Manufacturing Standard Operating Procedures',
                         Creator: 'Manufacturing LLC',
                         CreationDate: updated_at_iso8824,
                         ModificationDate: updated_at_iso8824
                       })
    end

    def copyright
      "Copyright #{Sop::Constants::COPYRIGHT} 2014-#{Date.today.strftime('%Y')} Manufacturing LLC." \
      ' All Rights Reserved. Do not copy or distribute.'
    end

    def updated_at_iso8824
      str = updated_at.strftime('D:%Y%m%d%H%M%S%z')
      str[0..18] + '\'' + str[-2..-1] + '\''
    end

    class KramdownDocument < Kramdown::Document
      attr_accessor :metadata

      def initialize(source, metadata:, **options)
        @options = Kramdown::Options.merge(options).freeze
        self.metadata = metadata
        @root, @warnings = Kramdown::Parser::PageBreakingKramdown.parse(source, options)
      end

      def to_pdf
        options = ::Kramdown::Options.merge(@options.merge(@root.options[:options] || {}))
        converter = SopPdfConverter.send :new, @root, metadata: metadata, **options
        converter.convert(@root)
      end
    end
  end
end
