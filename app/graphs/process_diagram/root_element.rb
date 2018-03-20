# frozen_string_literal: true
require 'open3'

module ProcessDiagram
  class RootElement < Element
    attr_accessor :layout, :graphviz_out

    DEFAULT_NODE_OPTIONS = {
      rankdir: :TB,
      ratio: 1.1,
      splines: :polyline
    }.freeze

    def initialize(nodes, **options)
      @node_options = DEFAULT_NODE_OPTIONS.merge(options)
      @children = nodes.enum_for(:each_with_index).map do |node, i|
        EntryElement.new(node, i, self)
      end
      @root_element = self
    end

    def to_dot
      build_diagram.join("\n")
    end

    class GraphvizParseError < StandardError
      attr_accessor :dot
      def initialize(message, dot)
        @dot = dot
        super(message)
      end
    end

    class GraphvizOutput
      attr_accessor :message, :error_level
      def error?
        error_level == :error
      end

      def initialize(log_line)
        @error_level, @message = log_line.split(':').map(&:strip)
        if error_level == 'Warning'
          @error_level = :warning
        elsif error_level == 'Error'
          @error_level = :error
        end
      end

      def to_s
        message
      end

      def self.parse_output(str)
        str.split("\n").map(&:strip).reject(&:blank?).map { |t| GraphvizOutput.new(t) }
      end
    end

    def graphviz_error?
      graphviz_errors.any?
    end

    def graphviz_errors
      graphviz_out.select(&:error?)
    end

    def to_png
      pngdata, error = Open3.capture3('dot -Tpng', stdin_data: to_dot, binmode: true)
      @graphviz_out = GraphvizOutput.parse_output(error)
      raise_graphviz_error if graphviz_error?
      pngdata
    end

    def raise_graphviz_error
      message = graphviz_errors.map(&:to_s).join("\n")
      raise GraphvizParseError.new("Graphviz Error: #{message}", to_dot)
    end

    def inspect
      "#<#{self.class.name}:#{object_id} @root_element=#{children.inspect}>"
    end

    def flow_direction
      @node_options[:rankdir]
    end

    def node_options
      @node_options.to_a.map do |name, val|
        option_string(name, val)
      end.join('; ')
    end

    def build_diagram
      child_strings = children.map(&:build_diagram).flatten
      ['digraph G {', node_options, *child_strings, '}']
    end
  end
end
