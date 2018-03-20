# frozen_string_literal: true
require 'yaml'
module Manual
  class ProcessFlow < ApplicationRecord
    extend FriendlyId
    friendly_id :title, use: :slugged

    include ManualDocumentWorkflow
    has_many :change_logs, class_name: 'Manual::ChangeLog', as: :document
    accepts_nested_attributes_for :change_logs
    attr_accessor :data, :filename, :output_dir
    validate :yaml_should_be_valid
    validate :dot_should_be_valid, unless: :dot_unvailable?

    def yaml_should_be_valid
      return if valid_yaml?
      errors.add :body, 'Body must be valid YAML.'
    end

    def dot_unvailable?
      `which dot`.blank?
    end

    def dot_should_be_valid
      to_png
    rescue ProcessDiagram::RootElement::GraphvizParseError => ex
      # Rails.logger.warn ex.message
      Rails.logger.warn ex.dot
      errors.add :body, "Invalid dot: #{ex.message}"
    end

    def valid_yaml?
      ProcessDiagram.valid_body?(body)
    end

    def document_id
      "PF#{process_id || id}"
    end

    def to_png
      process_diagram.to_png
    end

    def to_pdf
      ProcessDiagram::Pdf.new(self).render
    end

    def to_dot
      process_diagram.to_dot
    end

    def output_filename
      "#{document_id} - #{title} v#{version}.pdf"
    end

    private

    def process_diagram
      @process_diagram ||= ProcessDiagram.from_yaml_body(body,
                                                         layout: layout,
                                                         aspect_ratio: aspect_ratio)
    end

    def graph_title
      title
    end
  end
end
