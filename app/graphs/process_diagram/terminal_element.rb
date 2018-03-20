# frozen_string_literal: true
module ProcessDiagram
  class TerminalElement < Element
    TERMINAL_DEFAULTS = {
      shape: :rectangle,
      height: 0.8,
      width: 1.5,
      style: 'filled,rounded'
    }.freeze
    TERMINAL_PRIMARY_COLOR = '#8cff3f'
    TERMINAL_SECONDARY_COLOR = '#bbbbbb'

    def default_options
      TERMINAL_DEFAULTS
    end

    def edge_options
      super.merge(arrowhead: :dot)
    end
  end
end
