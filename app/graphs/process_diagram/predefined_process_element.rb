# frozen_string_literal: true
module ProcessDiagram
  class PredefinedProcessElement < Element
    def node_options
      super.merge(height: 1.4,
                  shape: :plaintext)
    end

    def node_string
      options = node_options
      options[:label] = label_string
      "#{node_id.inspect} [#{options_string(options)}];"
    end

    PORTS = {
      TB: {
        same_rank: {
          incoming: :p0,
          outgoing: :p2
        },
        incoming: :p1,
        outgoing: :p1
      },
      LR: {
        same_rank: {
          incoming: :p1,
          outgoing: :p1
        },
        incoming: :p0,
        outgoing: :p2
      }
    }.freeze

    def same_rank_incoming_edge_id
      edge_connector_name + ':' +
        PORTS[root_element.flow_direction][:same_rank][:incoming].to_s
    end

    def same_rank_outgoing_edge_id
      edge_connector_name + ':' +
        PORTS[root_element.flow_direction][:same_rank][:outgoing].to_s
    end

    def incoming_edge_id
      edge_connector_name + ':' +
        PORTS[root_element.flow_direction][:incoming].to_s
    end

    def outgoing_edge_id
      # binding.pry
      edge_connector_name + ':' +
        PORTS[root_element.flow_direction][:outgoing].to_s
    end

    def edge_connector_name
      node_id.inspect
    end

    HEIGHT = 60

    def label_string
      <<-EOF
        <
        <table bgcolor="#{node_options[:fillcolor]}" height="1.4" BORDER="0" CELLBORDER="1" CELLSPACING="0">
          <tr>
            <td port="p0" width="1" height="#{HEIGHT}">&nbsp;</td>
            <td cellpadding="15" port="p1" width="100" height="#{HEIGHT}">#{label_to_html}</td>
            <td port="p2" width="1" height="#{HEIGHT}">&nbsp;</td>
          </tr>
        </table>
        >
      EOF
    end

    def label_to_html
      node.label.gsub(/\n/, '<br />')
    end
  end
end
