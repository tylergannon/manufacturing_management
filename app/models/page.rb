# frozen_string_literal: true
class Page < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  default_value_for :include_table_of_contents, false

  def normalized_title=(title)
    self.title = self.class.normalize_title(title)
  end

  def normalized_title
    title
  end

  def self.normalize_title(title)
    title.gsub(/\s+/, ' ').titleize.strip
  end

  def to_param
    title.gsub(/\s/, '_')
  end

  def self.find_by_title(title)
    title = normalize_title(title)
    find_by(slug: normalize_friendly_id(title))
  end

  def self.normalize_friendly_id(str)
    str.gsub(/\s/, '_').parameterize
  end

  def normalize_friendly_id(str)
    self.class.normalize_friendly_id(str)
  end

  concerning :FriendlyId do
    def slug_candidates
      [[:title]]
    end

    def should_generate_new_friendly_id?
      title_changed?
    end
  end
end
