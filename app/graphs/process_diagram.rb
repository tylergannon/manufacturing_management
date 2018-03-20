# frozen_string_literal: true
require 'yaml'
module ProcessDiagram
  def self.from_yaml_body(body, layout: nil, aspect_ratio: nil)
    options = {}
    options[:rankdir] = if layout.to_s == 'landscape'
                          :LR
                        else
                          :TB
                        end
    options[:ratio] = aspect_ratio if aspect_ratio

    root_node = ProcessTree::RootNode.new(yaml(body))
    RootElement.new(root_node.children, **options)
  end

  def self.valid_body?(body)
    yaml(body)
    true
  rescue
    false
  end

  def self.yaml(body)
    YAML.load("---\n#{body}")
  end

  private_class_method :yaml

  NAMED_STYLES = {
    '!!' => {
      fillcolor: '#FA7921',
      color: '#2E1606',
      penwidth: 2
    }
  }.freeze

  # https://coolors.co/e55934-d6dde0-fdf19d-9bc53d-2e1606
  COLORS = {
    process_element: {
      primary: {
        fillcolor: '#5BC0EB',
        color: '#2E1606'
      },
      secondary: {
        fillcolor: '#D6DDE0',
        color: '#2E1606'
      }
    },
    predefined_process_element: {
      primary: {
        fillcolor: '#5BC0EB',
        color: '#2E1606'
      },
      secondary: {
        fillcolor: '#D6DDE0',
        color: '#2E1606'
      }
    },
    terminal_element: {
      primary: {
        fillcolor: '#9BC53D',
        color: '#2E1606'
      },
      secondary: {
        fillcolor: '#D1E4A6',
        color: '#2E1606'
      }
    },
    decision_element: {
      primary: {
        fillcolor: '#FDE74C',
        color: '#2E1606'
      },
      secondary: {
        fillcolor: '#FDF19D',
        color: '#2E1606'
      }
    }
  }.freeze
end
