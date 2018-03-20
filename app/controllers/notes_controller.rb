# frozen_string_literal: true
class NotesController < ApplicationController
  load_and_authorize_resource :note, except: :create
  respond_to :js
  def create
    @note = Note.create note_params.merge(user: current_user)
    respond_with @note
  end

  def show
    respond_with @note
  end

  def edit
    respond_with @note
  end

  def update
    @note.update note_params
    respond_with @note
  end

  def destroy
    @note.destroy
    respond_with @note
  end

  private

  def note_params
    params.require(:note).permit(:noteworthy_id, :noteworthy_type, :notes)
  end
end
