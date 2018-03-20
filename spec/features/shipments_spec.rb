# frozen_string_literal: true
require 'rails_helper'

RSpec.shared_examples 'Managing Shipments' do
  describe '#create' do
    it 'Can create a shipment' do
      sign_in
      click_link 'Shipments'
      expect(page).to have_current_path(shipments_path)
      find("a[href='#{new_shipment_path}']").click

      date_select_today :shipment, :ships_on
      # fill_in "shipment[ships_on]", with: 2.weeks.from_now.strftime("%-d %B, %Y")
      find('input[name=\'shipment[ship_by_air]\']').select_option
      close_date_select
      find('input[type=submit]', visible: false).click
      expect(page).to have_current_path(%r{/shipments/\d+})
      @shipment_path = page.current_path
      @shipment_id   = page.current_path.match(/(\d+)$/)[1].to_i
    end
  end
end

RSpec.shared_examples 'Connecting Batches To Shipments' do
  describe 'Create Batch With Shipment' do
    let(:shipment_date) { 2.weeks.from_now.to_date }
    let(:shipment) { create :shipment, ships_on: shipment_date }
    let(:batch) { create :batch }
    before do
      shipment
      batch
    end

    let(:shipment_selector) do
      ["dt[data-name='Ships On'] + dd", { text: shipment.ships_on.strftime('%b %-d') }]
    end

    it 'Can connect an existing batch to this shipment' do
      sign_in
      visit batch_path(batch)
      expect(batch.shipment).to be_nil
      expect(page).not_to have_selector(*shipment_selector)
      click_link 'Connect To Shipment'
      within '.modal' do
        find('option', text: shipment.name).select_option
        click_button 'Save'
      end

      expect(page).to have_selector(*shipment_selector)
    end

    it 'Can create a batch with this shipment' do
      sign_in
      click_link 'New Batch'
      chosen_select :batch, :recipe_id, 'Flavor1'
      date_select_today :batch, :production_date
      fill_in 'Gross PrimaryIngredient', with: '1000'
      close_date_select
      chosen_select :batch, :shipment_id, shipment.name
      click_button 'Create Batch'
      expect(page).to have_current_path(%r{batches/\d+})
      expect(page).to have_selector(*shipment_selector)
    end
  end
end

RSpec.describe 'Manage Batch Shipments', js: true, type: :feature do
  let(:user) { create :user, password: 'foobuckles', role: role, receive_issue_mailings: true }
  %w(manager admin supervisor).each do |role|
    context "#{role.titleize}:" do
      it_has_the_behavior_of 'Connecting Batches To Shipments' do
        let(:role) { role }
      end
    end
  end

  %w(manager admin).each do |role|
    context "#{role.titleize}:" do
      it_has_the_behavior_of 'Managing Shipments' do
        let(:role) { role }
      end
    end
  end
end
