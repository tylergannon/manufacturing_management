# frozen_string_literal: true
class SkusController < ApplicationController
  load_and_authorize_resource except: [:labels]

  respond_to :pdf, only: :labels

  def index
  end

  def labels
    respond_to do |format|
      format.html doend
    end
  end

  def new
  end

  def create
    @sku = Sku.create sku_params
    respond_with @sku, location: -> { skus_path }
  end

  def edit
  end

  def update
    @sku.update sku_params
    respond_with @sku, location: -> { skus_path }
  end

  def destroy
    @sku.destroy sku_params
    respond_with @sku, location: -> { skus_path }
  end

  private

  def sku_params
    params.require(:sku).permit(
      :title,
      :net_weight,
      :composed_of_id,
      :composed_quantity,
      :upc_filename,
      :flavor_id
    )
  end
end
