# frozen_string_literal: true
class IngredientsController < ApplicationController
  before_action :set_ingredient, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @ingredients = Ingredient.all
    respond_with(@ingredients)
  end

  def plan
    @days = params[:days] || 14
    return unless stale? etag: Batch.all, last_modified: Batch.maximum(:updated_at)

    @batches = Batch.future(@days)
    @ingredients = @batches.extending(IngredientsGetter).all_ingredients
  end

  def show
    respond_with(@ingredient)
  end

  def new
    @ingredient = Ingredient.new
    respond_with(@ingredient)
  end

  def edit
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)
    @ingredient.save
    respond_with(@ingredient)
  end

  def update
    @ingredient.update(ingredient_params)
    respond_with(@ingredient)
  end

  def destroy
    @ingredient.destroy
    respond_with(@ingredient)
  end

  private

  def set_ingredient
    @ingredient = Ingredient.find(params[:id])
  end

  def ingredient_params
    params.require(:ingredient).permit(:name, :instructions)
  end
end
