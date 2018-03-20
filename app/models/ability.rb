# frozen_string_literal: true
class Ability
  include CanCan::Ability

  MANAGER_ACTIONS = [:confirm, :cancel, :reject].freeze
  ADMINISTRATOR_ACTIONS = [:approve, :ship, :accept].freeze

  def initialize(user)
    if user.admin?
      can :manage, :all
    else
      grant_manager_abilities if user.manager?
      grant_everyone_abilities(user)
    end
  end

  def grant_manager_abilities
    can MANAGER_ACTIONS, Batch
    can :manage, Shipment
    can :accept, Batch, shipment: { workflow_state: 'preparing_for_shipping' }
    cannot :destroy, Shipment
  end

  def grant_everyone_abilities(user)
    can :read, :all
    cannot :read, [Dashboard::Task, Dashboard::Project]
    can :create, BatchFeedback
    can supervisor_batch_abilities, Batch

    can CRUD, Note, user_id: user.id

    can [:edit, :shipping_preparations], Shipment
    can :labels, :all
    cannot :ship, Shipment do |shipment|
      !shipment.can_transition?(:ship)
    end
  end

  CRUD = [:create, :read, :update, :destroy].freeze

  def supervisor_batch_abilities
    all_events = Batch.workflow_spec.event_names
    [:create, :edit, :update] + all_events - MANAGER_ACTIONS - ADMINISTRATOR_ACTIONS
  end
end
