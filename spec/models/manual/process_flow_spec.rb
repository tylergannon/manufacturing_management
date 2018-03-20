# frozen_string_literal: true
require 'rails_helper'
require 'open3'

RSpec.describe Manual::ProcessFlow, type: :model do
  let(:data) do
    # YAML::load_file(File.expand_path('../data.yml', __FILE__))
    File.read File.expand_path('../data.yml', __FILE__)
  end
  let(:flow) do
    <<-EOF
- "Raw PrimaryIngredient QA Foo":
  - "(Reject)Hazardous?":
    - "(Yes) Trigger Full Analysis[#fc5151]"
  - "(No) Raw PrimaryIngredient Disposal(process)"
- (Accept) Blow Drying
- Marinating
- "Raw Product QA":
  - "(Reject) Raw Product\nHazard?":
    - (Yes) Trigger Hazard 2
  - "(No) Raw Product Disposal"
- (Accept) Dehydrating
- "Finished\nProduct QA":
  - "To Process:\nUnmarketable Product"
- Cooling
- "To Process:\nPackaging"
- module
- Tight
- Dope
EOF
  end

  it 'Is able to generate a ' do
    a = Manual::ProcessFlow.new body: data
    puts a.to_dot
    File.open('foo.png', 'wb') do |f|
      f.write(a.to_png)
    end
  end
end
