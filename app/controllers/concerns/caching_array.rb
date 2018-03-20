# frozen_string_literal: true
class CachingArray < Array
  attr_accessor :current_page
  attr_accessor :total_pages
  attr_accessor :limit_value
  attr_accessor :offset_value
  attr_accessor :last_page
  attr_accessor :low_level_cache_key

  def last_page?
    last_page
  end

  def cache_key
    low_level_cache_key + '/views'
  end

  def self.fetch(arel, page, page_size, *key_args)
    cache_key = ([arel.cache_key] + key_args + [page || 1]).join('/')

    Rails.cache.fetch(cache_key) do
      new(arel, page, page_size, cache_key)
    end
  end

  def initialize(relation, page, per, cache_key)
    relation = relation.page(page).per(per)
    self.low_level_cache_key = cache_key
    self.current_page = relation.current_page
    self.total_pages = relation.total_pages
    self.limit_value = relation.limit_value
    self.offset_value = relation.offset_value
    self.last_page = relation.last_page?
    super(relation.to_a)
  end
end
