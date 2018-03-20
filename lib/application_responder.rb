# frozen_string_literal: true
class ApplicationResponder < ActionController::Responder
  module DickweedResponder
    class << self
      attr_accessor :flash_keys, :namespace_lookup, :helper
    end

    self.flash_keys = [:notice, :alert]
    self.namespace_lookup = false
    self.helper = Object.new.extend(
      ActionView::Helpers::TranslationHelper,
      ActionView::Helpers::TagHelper
    )

    def initialize(controller, resources, options = {})
      super
      @flash     = options.delete(:flash)
      @notice    = options.delete(:notice)
      @alert     = options.delete(:alert)
      @flash_now = options.delete(:flash_now) { :on_failure }
    end

    def to_html
      super
    end

    def to_js
      defined?(super) ? super : to_format
    end
  end

  # include DickweedResponder
  include Responders::FlashResponder
  include Responders::HttpCacheResponder

  # Redirects resources to the collection path (index action) instead
  # of the resource path (show action) for POST/PUT/DELETE requests.
  # include Responders::CollectionResponder
end
