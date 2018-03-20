# frozen_string_literal: true
module BatchFriendlyId
  extend ActiveSupport::Concern
  included do
    extend FriendlyId
    friendly_id :nil_slug, use: :slugged

    prepend FriendlyIdMethods
    after_create :make_slug!
  end

  module FriendlyIdMethods
    def nil_slug
      nil
    end

    def make_slug!
      update_column 'slug', calculate_slug if id_changed?
    end

    def calculate_slug
      (id.to_i.to_s(24).rjust(3, '0') + flavor&.abbreviation.to_s).upcase
    end

    def normalize_friendly_id(str)
      str.upcase
    end

    private

    def slug=(s)
      super
    end
  end
end
