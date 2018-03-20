# frozen_string_literal: true
class EventsController < ApplicationController
  load_resource :batch, find_by: :friendly_with_associations, only: :update
  load_resource :batch, find_by: :friendly, only: :show

  respond_to :js

  def show
    return unless stale? @batch
    @active_tab = 'overview'
    event_id = params[:id].to_sym
    @event   = @batch.current_state.find_event(event_id)
    respond_with @batch
  end

  def update
    @batch.transition! event_id, requested_by: current_user, model_params: batch_params

    if @batch.valid?
      flash_for_request_format[:notice] = t("flash.batch.events.#{event_id}")
    else
      flash_for_request_format[:error] = @batch.errors.values
    end

    respond_with @batch do |format|
      format.html do
        redirect_to @batch
      end
    end
  end

  private

  def event_id
    params[:id]
  end

  def choose_redirect_location
    if params['return_to']
      params['return_to']
    elsif params[:id] == 'accept' && @batch.shipment_id?
      shipment_path(@batch.shipment) + '#shipment_batches'
    else
      @batch
    end
  end

  def batch_params
    if params.key? :batch
      params.require(:batch).permit(BatchesController::ALLOWED_PARAMS)
    else
      {}
    end
  end
end
