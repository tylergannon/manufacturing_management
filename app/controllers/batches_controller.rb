# frozen_string_literal: true
class BatchesController < ApplicationController
  load_resource find_by: :friendly,
                only: [:show, :edit, :update]

  respond_to :json, only: :search
  respond_to :csv, only: :csv_index

  layout 'batch_layout', only: [:edit, :show]

  PAGE_SIZE = 10

  def index
    scope = params[:scope] || 'listing'
    @batches = Batch.send scope
    return unless stale? @batches

    @active_link = "#{scope}_batches"
    @page_title  = "#{scope.gsub(/with_(\w+)_state/, '\1').titleize} Batches"

    @batches = CachingArray.fetch @batches, params[:page], PAGE_SIZE, @active_link
    render :index
  end

  def csv_index
    @batches = Batch.all
    return unless stale? @batches
    send_data @batches.to_csv, filename: "batches-#{Date.today}.csv"
  end

  def search
    batches_etag  = Batch.all.cache_key(:created_at)
    last_modified = Batch.maximum(:created_at)

    return unless stale? etag: batches_etag, last_modified: last_modified

    @batches = Rails.cache.fetch(batches_etag) do
      Batch.with_flavor.order(production_date: :desc).as_json
    end

    render json: @batches
  end

  def show
    return unless stale? @batch
    @active_tab = params[:view] || 'overview'

    respond_with @batch do |format|
      format.html do
        render template: "batches/tabs/#{@active_tab}"
      end
      format.js do
        render action: 'add_to_shipment' if params[:view] == 'add_to_shipment'
      end
    end
  end

  def new
    @shipments  = Shipment.with_scheduled_state
    @recipes    = Recipe.current
    @cache_object = [@shipments, @recipes].max_by { |t| t.maximum(:updated_at) }

    return unless stale? @cache_object
    @batch = Batch.new
  end

  def edit
    return unless stale? @batch

    @active_tab = 'edit_batch'
    render template: 'batches/tabs/edit_batch'
  end

  def create
    @batch = Batch.create(batch_params)
    respond_with @batch, location: -> { @batch }
  end

  def update
    @batch.update batch_params
    if @batch.valid?
      flash[:notice] = 'Batch was updated.'
    else
      flash[:error]  = @batch.errors.values
    end
    respond_with @batch, flash: false, location: -> { edit_batch_path(@batch) }
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def batch_params
    params.require(:batch).permit(*ALLOWED_PARAMS)
  end

  ALLOWED_PARAMS =
    [
      { new_issue: [:problem, :steps_to_correct] },
      :flavor_id,
      :production_date,
      :manager_on_duty_id,
      :gross_fresh_primary_ingredient,
      :net_weight_sellable,
      :amount_of_primary_ingredient,
      :shipment_id,
      :recipe_id,
      :pouches_produced,
      :cartons_packed,
      :harvest_thick,
      :harvest_thin,
      :harvest_scraps,
      :unusable_thin_product,
      :unusable_thick_product,
      :unusable_other_product
    ].freeze
end
