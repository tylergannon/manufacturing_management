# frozen_string_literal: true
module Labels
  class CartonLabelsController < ApplicationController
    before_action :load_batches
    respond_to :pdf

    def index
      # if params.key? :pouches
      #   @batch.pouches_produced = params[:pouches].to_i
      #   @batch.freeze
      # end

      send_data CartonLabelDocument.new(@batches).render,
                filename: filename,
                type: 'application/pdf', disposition: 'inline'
    end

    private

    def filename
      if @shipment
        "Shipment #{@shipment.id} Labels.pdf"
      else
        "Batch #{@batches.first.batch_number} Labels.pdf"
      end
    end

    def load_batches
      if params[:batch_id]
        @batches = [Batch.friendly.find(params[:batch_id])]
      else
        @shipment = Shipment.find(params[:shipment_id])
        @batches  = @shipment.batches
      end
    end
  end
end
