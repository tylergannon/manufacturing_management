# frozen_string_literal: true
module ProcessTree
  class RootNode < Node
    def initialize(data)
      @data = data
      @label = 'root'
      build_children
      super()
    end

    def build_children
      @children = [Node.build(data)].compact
    end
  end
end
