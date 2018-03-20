# frozen_string_literal: true
class RecipeIngredientsController < ApplicationController
  load_and_authorize_resource :recipe, find_by: :slug
  load_and_authorize_resource :recipe_ingredient, through: :recipe

  respond_to :html, :js

  def new
    respond_with @recipe, @recipe_ingredient
  end

  def create
    @recipe_ingredient.attributes = recipe_ingredient_params
    @recipe_ingredient.save
    respond_with @recipe, @recipe_ingredient
  end

  def update
    @recipe_ingredient.attributes = recipe_ingredient_params
    @recipe_ingredient.save
    respond_with @recipe, @recipe_ingredient
  end

  def destroy
    @recipe_ingredient.destroy
    respond_with @recipe, @recipe_ingredient
  end

  private

  def recipe_ingredient_params
    params.require(:recipe_ingredient).permit(
      :ingredient_id,
      :parts_per_hundred,
      :grams_per_kilo_primary_ingredient
    )
  end
end
