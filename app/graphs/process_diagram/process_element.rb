# frozen_string_literal: true
module ProcessDiagram
  class ProcessElement < Element
    DEFAULT_NODE_OPTIONS = {
      shape: :rectangle,
      height: 0.8,
      width: 1.5,
      style: 'filled',
      fillcolor: 'white'
    }.freeze

    def default_options
      DEFAULT_NODE_OPTIONS
    end
  end
end
