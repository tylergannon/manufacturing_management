# frozen_string_literal: true
module PdfStylesheet
  extend ActiveSupport::Concern

  SPECIAL_ELEMENTS = [:header].freeze
  ELEMENTS = [:root, :p, :blockquote, :ul, :ol, :li, :dl,
              :dt, :dd, :math, :hr, :codeblock,
              :table, :text, :em, :strong, :a, :codespan,
              :br, :smart_quote, :typographic_sym, :entity,
              :abbreviation, :img, :xml_comment].freeze

  ELEMENTS.each do |element|
    define_method "#{element}_options" do |el, options|
      super(el, options).merge(styles(element))
    end
  end

  def header_options(el, options)
    element_name = "header#{el.options[:level]}".to_sym
    super(el, options).merge(styles(element_name))
  end

  def document_options(_)
    super.merge(styles(:document))
  end

  def styles(element)
    self.class.styles.select { |s| s.match?(element) }.each_with_object({}) do |style, result|
      result.merge! style.to_h
    end
  end

  module ClassMethods
    def style(*elements, &block)
      styles << StyleRule.new(elements, &block)
    end

    def styles
      @styles ||= []
    end
  end

  class StyleRule
    include Prawn::Measurements

    def initialize(*elements, &block)
      @matched_elements = [elements].flatten
      instance_exec(&block)
    end

    def match?(element)
      @matched_elements.include?(element)
    end

    def to_h
      defined_elements.each_with_object({}) do |rule_name, hash|
        if instance_variable_get("@#{rule_name}")
          hash[rule_name] = instance_variable_get("@#{rule_name}")
        end
      end
    end

    def method_missing(method, *args)
      super unless args.count == 1
      instance_variable_set("@#{method}", args.first)
    end

    def respond_to_missing?(_method)
      true
    end

    private

    def defined_elements
      element_ivars.map { |t| t.to_s.delete('@').to_sym }
    end

    def element_ivars
      instance_variables.reject { |t| t == :@matched_elements }
    end
  end
end
