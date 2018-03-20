# frozen_string_literal: true
class SopPdfConverter < Kramdown::Converter::Pdf
  include Sop::Stylesheet
  include Sop::CoverPage
  include Sop::TableOfContents
  include Sop::PageHeaders
  include Sop::PageFooters
  include Encryption

  attr_accessor :metadata

  def initialize(root, metadata:, **options)
    super(root, options)
    @metadata = metadata
  end
end
