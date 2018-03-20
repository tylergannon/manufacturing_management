# frozen_string_literal: true
class CartonLabelDocument < PdfDocument
  LABELS_PER_ROW = 4
  ROWS_PER_PAGE  = 17
  LABELS_PER_PAGE = LABELS_PER_ROW * ROWS_PER_PAGE

  PTS_PER_MM = 2.83464567
  MARGIN_TOP = 7.78
  MARGIN_LEFT = 8.7

  COLUMN_WIDTH = 48 * PTS_PER_MM
  ROW_HEIGHT   = 16.55 * PTS_PER_MM

  attr_accessor :batches

  def initialize(*batches)
    self.batches = [batches].flatten

    super()
  end

  def document
    @document ||= Prawn::Document.new page_size: 'A4',
                                   margin: [MARGIN_TOP * PTS_PER_MM, MARGIN_LEFT * PTS_PER_MM],
                                   skip_page_creation: true
  end

  def label_for(batch)
    "Best By #{batch.shipment.expiration_date.strftime('%m/%d/%y')}\nBatch #{batch.batch_number}"
  end

  def num_labels(batch)
    (pouch_count(batch).to_f / 8).ceil
  end
  # ((pouch_count(batch).to_f / 8).ceil.to_f / LABELS_PER_PAGE).ceil * LABELS_PER_PAGE

  def item_array
    batches.to_a.map do |batch|
      [label_for(batch)] * num_labels(batch)
    end.flatten
  end

  def item_table
    item_array
      .in_groups_of(LABELS_PER_ROW, '')
      .in_groups_of(ROWS_PER_PAGE, [''] * LABELS_PER_ROW)
  end

  def build_pdf
    item_table.each do |page|
      start_new_page

      font('Helvetica', style: :bold, size: 14)

      table page,
            cell_style: {
              width: COLUMN_WIDTH,
              height: ROW_HEIGHT,
              padding: [6, 8],
              borders: []
            }
    end
  end

  # def build_label_data()
end
