# frozen_string_literal: true
class DashboardManifest
  DASHBOARDS = [
    :configurations,
    :shipments,
    :flavors,
    :batches,
    :users,
    :ingredients,
    :recipes
  ].freeze

  ROOT_DASHBOARD = :batches
end
