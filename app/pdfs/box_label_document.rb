# frozen_string_literal: true
class BoxLabelDocument < PdfDocument
  LABELS_PER_ROW = 2
  ROWS_PER_PAGE  = 4
  LABELS_PER_PAGE = LABELS_PER_ROW * ROWS_PER_PAGE

  PTS_PER_MM = 2.83464567
  MARGIN_TOP = 0
  MARGIN_LEFT = 0

  COLUMN_WIDTH = 105 * PTS_PER_MM
  ROW_HEIGHT   = 74.18 * PTS_PER_MM

  attr_accessor :batch, :batches, :items

  def initialize(items)
    @items = items
    super()
  end

  def self.for_shipment(shipment)

  end

  def document
    @document ||= Prawn::Document.new page_size: 'A4',
                                       margin: [MARGIN_TOP * PTS_PER_MM, MARGIN_LEFT * PTS_PER_MM],
                                       skip_page_creation: true
  end

  def make_page(page)
    page.each_with_index do |row, i|
      row.each_with_index do |batch, j|
        box_dim = [(j * COLUMN_WIDTH), (4 - i) * ROW_HEIGHT]
        bounding_box(box_dim, width: COLUMN_WIDTH, height: ROW_HEIGHT) do
          print_single_label(batch) if batch
        end
      end
    end
  end

  def num_labels(batch)
    2 * (pouch_count(batch).to_f / 48).ceil
  end

  def item_array
    items.to_a.map do |batch|
      [batch] * num_labels(batch)
    end.flatten
  end

  LABELS_PER_ROW = 2
  ROWS_PER_PAGE  = 4

  def item_table
    items
      .in_groups_of(LABELS_PER_ROW, nil)
      .in_groups_of(ROWS_PER_PAGE, [nil] * LABELS_PER_ROW)
  end

  def print_single_label(label)
    standard_text_box 24, 10, 'Product Name'
    standard_text_box 20, 34, label.flavor_description
    standard_text_box 16, 54, 'Contains: [Quantity]'
    standard_text_box 12, 71, label.lot_description
    print_best_by
    print_expiration_date(label.expiration_date)
    print_upc_image(label.upc_image)
  end

  def print_upc_image(upc_file)
    image upc_file,
          at: [10, 90], width: (COLUMN_WIDTH - 20)
  end

  INDENT = 23

  def print_best_by
    font('Helvetica', size: 20) do
      text_box 'Best By', at: [INDENT + 0, ROW_HEIGHT - 95], width: COLUMN_WIDTH, align: :left
    end
  end

  def standard_text_box(font_size, location, text)
    font('Helvetica', size: font_size) do
      text_box text,
               at: [0, ROW_HEIGHT - location],
               width: COLUMN_WIDTH,
               align: :center
    end
  end

  def print_expiration_date(expiration_date)
    font('Helvetica', size: 36) do
      text_box expiration_date,
               at: [INDENT + 73, ROW_HEIGHT - 90],
               width: COLUMN_WIDTH, align: :left
    end
  end

  def build_pdf
    item_table.each do |page|
      start_new_page
      make_page(page)
    end
  end

  UPC_PATH = Rails.root.join('app', 'assets', 'images', 'upcs').freeze

  class << self
    def from_shipment(shipment)
      items = shipment_items_for_flavor(shipment, Flavor.flavor1, shipment.boxes_ordered_flavor1) +
              shipment_items_for_flavor(shipment, Flavor.flavor2, shipment.boxes_ordered_flavor2) +
              shipment_items_for_flavor(shipment, Flavor.flavor3, shipment.boxes_ordered_flavor3)
      new items
    end

    def from_batch(batch)
      items = (1..batch.master_boxes).to_a.map do |i|
        [batch_item(batch)]*2
      end.flatten
      new items
    end

    def shipment_items_for_flavor(shipment, flavor, boxes_ordered)
      (1..boxes_ordered).to_a.map do |i|
        [shipment_item(shipment, flavor, i, boxes_ordered)]*2
      end.flatten
    end

    def shipment_item(shipment, flavor, box_no, total_boxes)
      Hashie::Mash.new({
        lot_description: "Lot ##{shipment.to_param}-#{flavor.abbreviation}, Box #{box_no}/#{total_boxes}",
        flavor_description: "#{flavor.sku.flavor_name} Flavor",
        expiration_date: shipment.expiration_date.strftime('%m/%d/%Y'),
        upc_image: UPC_PATH.join(flavor.sku.upc_filename)
      })
    end

    def batch_item(batch)
      Hashie::Mash.new({
        lot_description: "Lot ##{batch.shipment.to_param}-#{batch.flavor.abbreviation}",
        flavor_description: "#{batch.flavor.sku.flavor_name} Flavor",
        expiration_date: batch.shipment.expiration_date.strftime('%m/%d/%Y'),
        upc_image: UPC_PATH.join(batch.flavor.sku.upc_filename)
      })
    end
  end

  private_class_method :shipment_items_for_flavor, :shipment_item, :batch_item
end
