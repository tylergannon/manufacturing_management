# frozen_string_literal: true
module ProcessTree
  class StringNode < Node
    def initialize(label, data, edge_options: {}, node_options: {})
      @data  = data
      @label = label
      @node_options = node_options
      @edge_options = edge_options
      @children = [self.class.build(data)].compact
      super()
    end
  end
end
