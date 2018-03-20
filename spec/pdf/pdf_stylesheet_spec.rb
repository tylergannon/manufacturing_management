# frozen_string_literal: true
require 'rails_helper'

describe PdfStylesheet do
  let(:super_class) do
    Class.new do
      def root_options(_el, _)
        { size: 12, character_spacing: 3 }
      end
    end
  end

  let(:my_class) do
    Class.new(super_class) do
      include PdfStylesheet

      style :root do
        size 24
      end

      style :header1, :header2 do
        size 24
        character_spacing 3
      end

      style :header1 do
        character_spacing 4
      end

      style :header2 do
        top_padding 10
        size 14
      end
    end
  end

  subject { my_class.new }

  describe '*_options methods' do
    it 'should merge superclass style options with styles defined in the stylesheet' do
      expect(subject.styles(:root)).to eq(size: 24)
      expect(subject.root_options(:foo, :bar)).to eq(character_spacing: 3, size: 24)
    end
  end

  it 'should cascade the styles' do
    expect(subject.styles(:header1)).to eq(character_spacing: 4, size: 24)
  end

  it 'should cascade other styles' do
    expect(subject.styles(:header2)).to eq(character_spacing: 3, size: 14, top_padding: 10)
  end

  describe PdfStylesheet::StyleRule do
    subject do
      described_class.new :header1 do
        size 24
        character_spacing 3
      end
    end

    it 'should match the matching elements' do
      expect(subject.match?(:header1)).to be_truthy
    end
    it 'should not match non-matching elements' do
      expect(subject.match?(:header2)).to be_falsey
      puts subject.instance_variables.inspect
    end

    it 'should give the correct hash' do
      expect(subject.to_h).to eq(size: 24, character_spacing: 3)
    end
  end
end
