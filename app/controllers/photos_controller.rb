# frozen_string_literal: true
class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :edit, :update, :destroy, :secure_download]

  respond_to :html, :js, :json

  def index
    @photos = Photo.all
    respond_with(@photos)
  end

  def show
    respond_with(@photo)
  end

  def secure_download
    redirect_to(@photo.photo.expiring_url(2))
  end

  def new
    @photo = Photo.new
    respond_with(@photo)
  end

  def edit
  end

  def create
    @photo = Photo.new(photo_params)
    @photo.save
    respond_with(@photo) do |format|
      format.json do
        render json: @photo
      end
    end
  end

  def update
    @photo.update(photo_params)
    respond_with(@photo)
  end

  def destroy
    @photo.destroy
    respond_with(@photo)
  end

  private

  def set_photo
    @photo = Photo.find(params[:id])
  end

  def photo_params
    params.require(:photo).permit(:batch_feedback_id, :owner_type, :owner_id, :photo)
  end
end
