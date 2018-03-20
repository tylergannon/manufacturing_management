# frozen_string_literal: true
module ProcessDiagram
  class EntryElement < Element
    attr_accessor :label

    def initialize(node, i, root_element)
      @root_element = root_element
      @label = "label#{i}"
      @node  = node
      @children = [Element.build(node, root_element)]
    end

    def build_diagram
      ["#{label.inspect} [#{options_string(node_options)}];"] + build_children
    end

    def edge_connector_name
      label.inspect
    end

    DEFAULT_EDGE_OPTIONS = {
      xlabel: 'Entry'
    }.freeze

    def edge_options(child)
      options_string(DEFAULT_EDGE_OPTIONS.merge(child.edge_options))
    end

    def node_options
      {
        shape: :point
      }
    end
  end
end
