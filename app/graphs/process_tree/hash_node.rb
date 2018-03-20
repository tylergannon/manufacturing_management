# frozen_string_literal: true
module ProcessTree
  class HashNode < Node
    def initialize(data, child_data, edge_options: {}, node_options: {})
      @node_options = node_options
      @edge_options = edge_options

      self.label, hash_data = data.first
      @children = [
        (Node.build(child_data.shift, child_data) if child_data),
        Node.build(hash_data)
      ].compact
      super()
    end
  end
end
