# frozen_string_literal: true
module Dashboard
  module ProjectsHelper
    def project_color(name)
      case name
      when 'yellow' then 'bg-warning'
      when 'green'  then 'bg-success'
      when 'red'    then 'bg-danger'
      end
    end

    def tag_pull(tag = 'primary', pull = 'right')
      {
        tag: 'span',
        class: ['tag', "tag-#{tag}", 'tag-pill', "pull-xs-#{pull}"]
      }
    end
  end
end
