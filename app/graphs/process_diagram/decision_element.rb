# frozen_string_literal: true
module ProcessDiagram
  class DecisionElement < Element
    H = 1.3
    DEFAULT_OPTIONS = {
      shape: :diamond,
      width: H,
      height: H,
      fillcolor: '#fff042',
      style: 'filled'
    }.freeze

    attr_accessor :cluster
    def initialize(node, root_element)
      super
      return unless children.length > 1
      children[1..-1].each(&:cascade_secondary)
    end

    def default_options
      DEFAULT_OPTIONS
    end

    def first_child_edge(child)
      "#{outgoing_edge_id} -> #{child.incoming_edge_id} [#{options_string(child.edge_options)}];"
    end

    def second_child_edge(child)
      "#{same_rank_outgoing_edge_id} -> #{child.same_rank_incoming_edge_id}" \
        "[#{options_string(child.edge_options)},len=2];"
    end

    def build_children
      strings = []
      children.each do |child|
        strings += child.build_diagram
      end
      strings << first_child_edge(children.first)
      strings + secondary_child_edges
    end

    def secondary_child_edges
      if commands.include?('norank')
        different_rank_edges
      else
        same_rank_edges
      end
    end

    def different_rank_edges
      children[1..-1].map do |child|
        first_child_edge(child)
      end
    end

    def same_rank_edges
      same_rank_edges = children[1..-1].map do |child|
        second_child_edge(child)
      end
      ['{', 'rank=same;', *same_rank_edges, '}']
    end
  end
end
