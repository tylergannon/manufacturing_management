# frozen_string_literal: true
class BatchFeedbacksController < ApplicationController
  load_and_authorize_resource :batch
  load_and_authorize_resource :batch_feedback, through: :batch, except: [:create]

  respond_to :html

  def index
    respond_with(@batch_feedbacks)
  end

  def show
    respond_with(@batch_feedback)
  end

  def new
    @batch_feedback = @batch.batch_feedbacks.new(user: current_user)
    respond_with(@batch_feedback)
  end

  def edit
  end

  def create
    params = { user: current_user }.merge(batch_feedback_params)
    @batch_feedback = @batch.batch_feedbacks.new(params)

    @batch_feedback.save
    respond_with(@batch, @batch_feedback, location: -> { batch_path(@batch) + '#batch_feedback' })
  end

  def update
    @batch_feedback.update(batch_feedback_params)
    respond_with(@batch_feedback)
  end

  def destroy
    @batch_feedback.destroy
    respond_with(@batch_feedback)
  end

  private

  def set_batch_feedback
    @batch_feedback = BatchFeedback.find(params[:id])
  end

  def batch_feedback_params
    attrs = BatchFeedback::ENUMS + %i(sellable feedback_date notes)
    params.require(:batch_feedback).permit attrs
  end
end
