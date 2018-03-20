# frozen_string_literal: true
module BootstrapGridHelper
  def col_sizes(params = {})
    offsets = params.delete(:offset) || {}
    cols = params.to_a.map do |pair|
      "col-#{pair[0]}-#{pair[1]}"
    end.join(' ')

    offsets = offsets.to_a.map do |pair|
      "offset-#{pair[0]}-#{pair[1]}"
    end.join(' ')

    { class: "#{cols} #{offsets}" }
  end
end
