# frozen_string_literal: true
module Sop
  module PageFooters
    def finish_document(_root)
      super

      write_page_footers
    end

    private

    def write_page_footers
      @pdf.extend PdfDocumentFooter
      @pdf.write_page_footers
    end

    module PdfDocumentFooter
      include Sop::Constants
      def write_page_footers
        font COURIER_NEW do
          number_pages PAGE_NUMBER_FORMAT, **page_number_options
        end
      end

      private

      PAGE_NUMBER_FORMAT = "Page <page> of <total>\n" \
        "Copyright #{Sop::Constants::COPYRIGHT} 2016 Manufacturing LLC. Proprietary & Confidential. Do not reproduce or distribute."

      def page_number_options
        {
          at: [0, -35],
          color: 'afafaf',
          size: 8.4,
          page_filter: -> (page) { page != 1 },
          font: COURIER_NEW
        }.freeze
      end
    end
  end
end
