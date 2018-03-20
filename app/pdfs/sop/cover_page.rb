# frozen_string_literal: true
module Sop
  module CoverPage
    TITLE_CURSOR_POSITION    = 550
    SUBTITLE_CURSOR_POSITION = 400
    COPYRIGHT_CURSOR_POSITION = 40
    TITLE_SIZE               = 20
    SUBTITLE_SIZE            = 15
    COPYRIGHT_SIZE           = 10

    def setup_document(root)
      pdf = super
      pdf.extend CoverPageWriter
      pdf.write_cover_page(metadata)
      pdf
    end

    COPYRIGHT = "Copyright #{Sop::Constants::COPYRIGHT} 2016 Manufacturing LLC. Proprietary and Confidential.\n" \
        'Do not reproduce or distribute.'

    module CoverPageWriter
      extend ActiveSupport::Concern
      include Sop::Constants

      def write_cover_page(metadata)
        move_cursor_to TITLE_CURSOR_POSITION
        write_title(metadata.title)
        move_cursor_to SUBTITLE_CURSOR_POSITION
        write_subtitle(metadata)
        write_copyright
        start_new_page
      end

      private

      def write_copyright
        move_cursor_to COPYRIGHT_CURSOR_POSITION
        font COURIER_NEW, size: COPYRIGHT_SIZE do
          text COPYRIGHT, align: :center
        end
      end

      def write_title(title)
        font COURIER_NEW, size: 15 do
          text 'Manufacturing LLC', align: :center
          text 'Standard Operating Procedures', align: :center
        end
        move_down 50
        font 'Helvetica' do
          text title, align: :center, size: 25
        end
      end

      PAD_LENGTH = 22

      def padded_string(string1, string2, length = PAD_LENGTH, pad = ' ')
        padding = pad * (length - string1.length - string2.length)
        string1 + padding + string2
      end

      def write_subtitle(metadata)
        font COURIER_NEW, size: 14 do
          text padded_string('Document:', metadata.document_id), align: :center
          text padded_string('Author:', metadata.author), align: :center
          text padded_string('Version:', metadata.version), align: :center
          text padded_string('Updated:', metadata.updated_at), align: :center
        end
      end
    end
  end
end
