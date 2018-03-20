# frozen_string_literal: true
module Labels
  class BoxLabelsController < ApplicationController
    respond_to :pdf

    def index
      send_data pdf_document.render,
                filename: filename,
                type: 'application/pdf', disposition: 'inline'
    end

    private

    def filename
      if @shipment
        "Shipment #{@shipment.id} Box Labels.pdf"
      else
        "Batch #{@batch.batch_number} Box Labels.pdf"
      end
    end

    def pdf_document
      if params[:batch_id]
        @batch = Batch.friendly.find params[:batch_id]
        BoxLabelDocument.from_batch @batch
      else
        @shipment = Shipment.find(params[:shipment_id])
        BoxLabelDocument.from_shipment @shipment
      end
    end
  end
end
