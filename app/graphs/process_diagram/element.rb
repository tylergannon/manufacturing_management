# frozen_string_literal: true
module ProcessDiagram
  class Element
    attr_accessor :node, :diagram, :children, :primary, :diagram_node, :initial, :root_element
    delegate :label, :commands, :node_id, :command?, to: :node

    def initialize(node, root_element)
      @root_element = root_element
      @primary   = true
      @node      = node
      @children  = node.children.compact.map { |t| Element.build(t, root_element) }
    end

    def build_diagram
      [node_string] + build_children
    end

    def node_string
      "#{node_id.inspect} [#{options_string(node_options)}];" unless command?('resolve')
    end

    def node_id
      return @node_id if @node_id
      @node_id = if commands.include? 'uniq'
                   SecureRandom.uuid
                 else
                   node.label
                 end
    end

    def build_children
      children.map do |child|
        child.build_diagram +
          ["#{outgoing_edge_id} ->
            #{child.incoming_edge_id} [#{options_string(child.edge_options)}];".squish]
      end.flatten
    end

    def edge_connector_name
      node_id.inspect
    end

    def incoming_edge_id
      edge_connector_name
    end

    def outgoing_edge_id
      edge_connector_name
    end

    def same_rank_incoming_edge_id
      edge_connector_name
    end

    def same_rank_outgoing_edge_id
      edge_connector_name
    end

    def options_string(data)
      data.to_a.map do |name, value|
        option_string(name, value)
      end.join(',')
    end

    def option_string(name, value)
      "#{name}=" +
        case value
        when String
          if value =~ /^\s*\<.*\>\s$/m
            value.squish
          else
            value.inspect
          end
        else value.to_s
        end
    end

    def weight
      if primary
        4
      else
        1
      end
    end

    def edge_options
      options = {
        len: 0.5,
        weight: weight,
        fontsize: 17,
        fontname: 'Courier'
      }.merge(node.edge_options)
      options.reverse_merge!(len: 2) unless primary
      options
    end

    def self.build(node, root_element)
      "ProcessDiagram::#{node.node_type.to_s.classify}".constantize.new(node, root_element)
    end

    def node_options
      options = base_color_options.merge named_style
      options[:label] = label
      options.delete(:shape) if options[:shape] == 'process'
      options[:shape] = node.shape if node.shape
      options.merge! local_options.merge(node.node_options)
      default_options.merge options
    end

    def base_color_options
      COLORS[self.class.name.demodulize.underscore.to_sym][color_selector]
    end

    def color_selector
      if primary
        :primary
      else
        :secondary
      end
    end

    def named_style
      NAMED_STYLES[node.named_style] || {}
    end

    def cascade_secondary
      self.primary = false
      children.each(&:cascade_secondary)
    end

    def local_options
      if primary
        primary_options
      else
        secondary_options
      end
    end

    def primary_options
      {
        fontsize: 20,
        penwidth: 2.5,
        width: 4,
        fontname: 'Courier'
      }
    end

    def secondary_options
      {
        fontsize: 16,
        fontname: 'Courier'
      }
    end

    def default_options
      { fontname: Sop::Constants::COURIER_NEW }
    end

    def inspect
      "#<#{self.class.name}::#{node&.label&.inspect} @children=#{children.inspect}>"
    end
  end
end
