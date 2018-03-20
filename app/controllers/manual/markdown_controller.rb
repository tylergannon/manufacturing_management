# frozen_string_literal: true
module Manual
  class MarkdownController < ApplicationController
    include ActionView::Helpers::JavaScriptHelper
    respond_to :json
    def show
      input = params[:markdown_text]
      @html = Kramdown::Document.new(input).to_html.html_safe
    end
  end
end
