# frozen_string_literal: true
json.array!(@ingredients) do |ingredient|
  json.extract! ingredient, :id, :name, :instructions
  json.url ingredient_url(ingredient, format: :json)
end
