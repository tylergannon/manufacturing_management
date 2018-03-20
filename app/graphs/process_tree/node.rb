# frozen_string_literal: true
module ProcessTree
  class Node
    attr_accessor :children, :data, :node_options, :edge_options, :commands, :label, :named_style,
                  :shape

    def initialize
      @commands = []
      parse_label
    end

    def command?(str)
      commands.include?(str)
    end

    def node_type
      return :predefined_process_element if shape == 'process'

      case children.length
      when 0
        if command?('resolve')
          # binding.pry
          :process_element
        else
          :terminal_element
        end
      when 1 then :process_element
      else :decision_element
      end
    end

    def self.build(data, children = nil)
      case data
      when Hash
        HashNode.new(data, children)
      when String
        StringNode.new(data, children)
      when Array
        build(data.shift, data) unless data.empty?
      end
    end

    private

    # EDGE_LABEL_REGEX = 'foo'

    # looks for stuff like "(No)Foobar"
    def parse_for_edge_label
      return unless label =~ /^\(([^\)]+)\)(.*)$/m

      edge_options[:xlabel] = $LAST_MATCH_INFO[1]
      @label = $LAST_MATCH_INFO[2].strip
    end

    # looks for "Foo(diamond)"
    def parse_for_shape_name
      return unless label =~ /^(.*)\(([^\]]+)\)\s*$/m
      @label = $LAST_MATCH_INFO[1].strip
      @shape = $LAST_MATCH_INFO[2].strip
    end

    # looks for "Foo{uniq}"
    # If found then the id of the diagram node will be a unique id, not the label itself.
    def parse_for_commands
      return unless label =~ /^(.*)\{([^\]]+)\}\s*$/m
      @label = $LAST_MATCH_INFO[1].strip
      @commands = $LAST_MATCH_INFO[2].strip.split(',').map(&:strip)
    end

    # Looks for named styles
    # "Foo[!!]"
    def parse_for_named_style
      return unless label =~ /^(.*)\[([^\]]+)\]\s*$/m
      @named_style = $LAST_MATCH_INFO[2]
      @label = $LAST_MATCH_INFO[1].strip
    end

    def parse_label
      @full_label = label
      parse_for_edge_label
      parse_for_commands
      parse_for_named_style
      parse_for_shape_name
    end
  end
end
