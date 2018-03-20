# frozen_string_literal: true
require 'rails_helper'

describe ProcessDiagram do
  describe ProcessDiagram::PredefinedProcessElement do
    let(:body) { '- Foo (process)' }
    let(:diagram) { ProcessDiagram.from_yaml_body(body) }

    it 'should have the correct element' do
      expect(diagram.children.first.children.first).to be_kind_of(described_class)
    end

    it 'should create the correct DOT' do
      puts diagram.to_dot
    end
  end
end
