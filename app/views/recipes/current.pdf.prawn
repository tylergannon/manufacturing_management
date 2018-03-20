prawn_document do |pdf|
  recipe_report = RecipeReport.new(pdf)
  recipe_report.build_pdf
end
