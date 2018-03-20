# frozen_string_literal: true
class RecipesController < ApplicationController
  load_and_authorize_resource :flavor, find_by: :friendly, except: [:index, :current]
  load_and_authorize_resource :recipe, through: :flavor,
                                       find_by: :friendly_with_default,
                                       except: [:index, :current]

  respond_to :pdf, :xlsx
  respond_to :html, :js

  def current
    @recipes = Flavor.all.map(&:default_recipe)
    respond_to do |format|
      format.pdf
      format.xlsx do
        render xlsx: 'current', filename: "Manufacturing Recipes #{Date.today}.xlsx"
      end
    end
  end

  def index
    if params.key?(:flavor_id)
      @flavor  = Flavor.friendly.find(params[:flavor_id])
      @recipes = @flavor.recipes
      authorize! :read, @recipes
      respond_with(@recipes) do |format|
        format.json do
          render json: @recipes
        end
      end
    else
      render template: 'recipes/recipes_index'
    end
  end

  def show
    @title = show_page_title
    @primary_ingredient_quantity = (params[:primary_ingredient_quantity] || 50).to_f
    @multiplier    = 1.0
    respond_with(@flavor, @recipe)
  end

  def sort
    order = params['order']
    order.each_with_index do |id, i|
      @flavor.recipes.find_by(id: id.to_i).update(sort_key: i)
    end
  end

  def copy
    @new_recipe = @flavor.recipes.create(title: "Copy of #{@recipe.title}")
    @recipe.recipe_ingredients.each do |recipe_ingredient|
      @new_recipe.recipe_ingredients.create \
        grams_per_kilo_primary_ingredient: recipe_ingredient.grams_per_kilo_primary_ingredient,
        ingredient_id: recipe_ingredient.ingredient_id
    end

    redirect_to [:edit, @flavor, @new_recipe]
  end

  def new
    if params.key?(:copy_recipe_id)
      recipe_to_copy = Recipe.friendly.find(params[:copy_recipe_id])
      @recipe.flavor = recipe_to_copy.flavor
      @recipe.save
      redirect_to edit_flavor_recipe_path(@flavor, @recipe)
    else
      respond_with @flavor, @recipe
    end
  end

  def edit
  end

  def create
    @recipe = @flavor.recipes.new(recipe_params)
    @recipe.save
    respond_with @recipe, location: -> { edit_flavor_recipe_path(@flavor, @recipe) }
  end

  def update
    @recipe.update(recipe_params)
    respond_with(@flavor, @recipe)
  end

  def destroy
    @recipe.destroy
    respond_with(@flavor, @recipe)
  end

  private

  def show_page_title
    if params[:id] == Recipe::ACTIVE_RECIPE_ID
      "Current #{@flavor.name} Flavor Recipe"
    else
      @recipe.long_name
    end
  end

  def recipe_params
    params.require(:recipe).permit(:flavor_id, :slug, :title, :description, :sort_key)
  end
end
