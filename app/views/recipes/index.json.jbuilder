# frozen_string_literal: true
json.array!(@recipes) do |recipe|
  json.extract! recipe, :id, :flavor_id, :slug
  json.url recipe_url(recipe, format: :json)
end
