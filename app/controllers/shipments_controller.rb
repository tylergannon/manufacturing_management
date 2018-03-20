# frozen_string_literal: true
class ShipmentsController < ApplicationController
  # Load extra data when displaying.  Otherwise just the object.
  USER_DISPLAY_ACTIONS = [:show, :shipping_preparations, :shipped].freeze
  load_and_authorize_resource :shipment, find_by: :hex_with_show_data,
                                         only: USER_DISPLAY_ACTIONS
  load_and_authorize_resource :shipment, find_by: :hex,
                                         except: USER_DISPLAY_ACTIONS

  PAGE_SIZE = 10

  respond_to :html

  TITLES = {
    'index' => 'Shipments',
    'recent' => 'Shipments Already Shipped',
    'all' => 'All Shipments'
  }.freeze

  def index
    @scope = params[:view] || 'index'
    @shipments = Shipment.send @scope
    return unless stale? etag: @shipments, last_modified: @shipments.maximum(:updated_at)

    @page_title = TITLES[@scope]
    @shipments = CachingArray.fetch @shipments, params[:page], PAGE_SIZE, @scope
    respond_with @shipments
  end

  def secure_download
    attribute = params[:attribute]
    redirect_to @shipment.send(attribute).expiring_url(2)
  end

  def shipping_preparations
    respond_with @shipment if stale? @shipment
  end

  def shipped
    respond_with @shipment if stale? @shipment
  end

  def workflow_event
    @shipment.transition! params[:event_id]

    redirect = case params[:event_id]
               when 'prepare_for_shipping'
                 shipping_preparations_shipment_path(@shipment)
               when 'ship'
                 shipped_shipment_path(@shipment)
               else
                 @shipment
               end

    redirect_to redirect
  end

  def show
    if @shipment.preparing_for_shipping?
      redirect_to shipping_preparations_shipment_path(@shipment)
    elsif @shipment.shipped?
      redirect_to shipped_shipment_path(@shipment)
    elsif stale? @shipment
      respond_with(@shipment)
    end
  end

  def add_batch
    batch = Batch.find(params[:new_batch_id])
    batch.update shipment_id: @shipment.id
    redirect_to @shipment
  end

  def new
    @shipment = Shipment.new
    respond_with(@shipment)
  end

  def edit
  end

  def create
    @shipment = Shipment.new(shipment_params)
    @shipment.save
    respond_with(@shipment)
  end

  def update
    @shipment.update(shipment_params)
    respond_with(@shipment)
  end

  def destroy
    @shipment.destroy
    respond_with(@shipment)
  end

  private

  def set_shipment
    @shipment = Shipment.find(params[:id])
  end

  SHIPMENT_PARAMS = [:ships_on,
                     :ship_by_air,
                     :house_airway_bill,
                     :master_airway_bill,
                     :carrier,
                     :notes,
                     :commercial_invoice,
                     :packing_list,
                     :boxes_packed_flavor1,
                     :boxes_packed_flavor2,
                     :boxes_packed_flavor3,
                     :boxes_ordered_flavor1,
                     :boxes_ordered_flavor3,
                     :boxes_ordered_flavor2]

  def shipment_params
    params.require(:shipment).permit(*SHIPMENT_PARAMS)
  end
end
