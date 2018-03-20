# frozen_string_literal: true
module Manual
  module ProcessFlowsHelper
    def link_to_process_flow(pf)
      link_title = "#{pf.document_id} #{pf.title}"
      link_to(link_title, pf)
    end
  end
end
