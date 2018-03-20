# frozen_string_literal: true
class PdfDocument
  include Prawn::View

  DEFAULT_SPACE = 5
  def initialize
    register_fonts
  end

  def default_space
    DEFAULT_SPACE
  end

  def document
    @document ||= Prawn::Document.new page_size: 'A4'
  end

  def pouch_count(batch)
    batch.pouches_produced.to_i.positive? ? batch.pouches_produced : batch.expected_pouch_count
  end

  def render
    build_pdf
    super
  end

  def h1(t)
    font_size 16 do
      font('Helvetica', style: :bold) do
        text t
      end
    end
  end

  def space
    move_down default_space
  end

  def h2(t)
    font_size 14 do
      font 'Helvetica', style: :bold do
        text t
      end
    end
  end

  private

  def register_fonts
    font_families.update(
      'MyriadPro' => {
        normal: Rails.root.join('app', 'assets', 'fonts', 'MyriadPro-Regular.otf'),
        bold: Rails.root.join('app', 'assets', 'fonts', 'MyriadPro-Bold.otf')
      }
    )
  end
end
