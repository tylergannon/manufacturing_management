# frozen_string_literal: true
class Batch < ApplicationRecord
  include BatchWorkflow
  include BatchFriendlyId
  include BatchPresentation
  include BatchScopes
  include BatchValidations

  has_many :notes, as: :noteworthy

  delegate :flavor, to: :recipe

  after_commit :manage_gcal_event

  def manage_gcal_event
    if cancelled?
      gcal_event.destroy if gcal_event.present?
    else
      gcal_event.present? ? gcal_event.touch : create_gcal_event
    end
  end

  def issue?
    issues.current.present?
  end

  def new_issue=(params = {})
    issues.create(params)
  end

  concerning :Associations do
    included do
      has_one :gcal_event, dependent: :destroy
      has_many :issues, dependent: :destroy, autosave: true do
        def current
          with_opened_state.first
        end
      end
      belongs_to :flavor
      belongs_to :recipe
      belongs_to :shipment, touch: true
      belongs_to :manager_on_duty, class_name: 'User', foreign_key: 'manager_on_duty_id'
      has_many :batch_logs, dependent: :destroy
      has_many :photos, as: :owner, dependent: :destroy
      belongs_to :primary_ingredient_shipment
      has_many :weather_readings, dependent: :delete_all
      has_many :batch_feedbacks, dependent: :destroy
    end
  end

  concerning :Callbacks do
    included do
      before_save :set_recipe_if_empty
    end

    def set_recipe_if_empty
      self.recipe ||= flavor.default_recipe
    end
  end

  def log_action!(action, approved_by)
    batch_logs.create! action: action, approved_by: approved_by,
                       approved_at: Time.zone.now
  end

  def batch_number
    slug
  end

  def coding_printer_setting
    formatted_expiration_date + ' ' + batch_number if formatted_expiration_date
  end

  def expiration_date
    shipment&.expiration_date
  end

  POUCH_SIZE = 0.043 # kg
  MEAT_REDUCTION_RATIO = 4
  KGS_MEAT_PER_POUCH = 0.28

  def expected_pouch_count
    (gross_fresh_primary_ingredient / KGS_MEAT_PER_POUCH).to_i
    # (approximate_jerky_harvest / POUCH_SIZE).to_i
  end

  def effective_pouch_count
    pouches_produced.to_i.positive? ? pouches_produced : expected_pouch_count
  end

  def master_boxes
    exact_master_boxes.ceil
  end

  def exact_master_boxes
    effective_pouch_count.to_f / 48
  end

  def approximate_jerky_harvest
    (gross_fresh_primary_ingredient / MEAT_REDUCTION_RATIO).round(1)
  end

  def pouches_to_prepare_before
    (expected_pouch_count * 0.85).to_i
  end

  def halted_callback_hook(filter)
  end
end
