# frozen_string_literal: true
module Kramdown
  module Parser
    class PageBreakingKramdown < Kramdown
      def initialize(source, options)
        super(self.class.replace_special_characters(source), options)
      end

      def self.replace_special_characters(source)
        refer_to_other_documents(source).gsub(/\(c\)/, Sop::Constants::COPYRIGHT)
      end

      CLASS_SHORTCUTS = {
        'SOP' => 'Manual::StandardOperatingProcedure',
        'PF'  => 'Manual::ProcessFlow'
      }

      def self.refer_to_other_documents(source)
        source.gsub(/\[\[([A-Z]+)(\d+)\:title\]\]/) do
          class_name = CLASS_SHORTCUTS[$LAST_MATCH_INFO[1]]
          model = class_name.constantize.find_by(process_id: $LAST_MATCH_INFO[2])
          "_#{$LAST_MATCH_INFO[1]}#{$LAST_MATCH_INFO[2]}: #{model.title}_"
        end.gsub(/\[\[([A-Z]+)(\d+)\]\]/) do |match|
          class_name = CLASS_SHORTCUTS[$LAST_MATCH_INFO[1]]
          model = class_name.constantize.find_by(process_id: $LAST_MATCH_INFO[2])
          unless class_name && model
            match
          else
            "_[#{$LAST_MATCH_INFO[1]}#{$LAST_MATCH_INFO[2]}: #{model.title}](#{ENV['HOST_NAME']}/#{class_name.pluralize.underscore}/#{model.to_param})_"
          end
        end
      end

      PAGE_BREAK = /^[ -]{19,}/

      # Parse the line break at the current location.
      def parse_page_break
        start_line_number = @src.current_line_number
        @src.pos += @src.matched_size
        @tree.children << new_block_el(:page_break, nil, nil, location: start_line_number)
        true
      end

      @@parsers.delete(:page_break) if parser(:page_break)
      define_parser(:page_break, PAGE_BREAK)

      def parse
        unless @block_parsers.include?(:page_break)
          @block_parsers.unshift(:page_break)
        end
        super
      end
    end
  end
end
