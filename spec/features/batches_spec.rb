# frozen_string_literal: true
require 'rails_helper'

RSpec::Matchers.define :accept_value do |acceptable|
  match do |attribute|
    @error = nil
    unless subject.is_a? ApplicationRecord
      puts 'You might need to set the subject to a model for your form setters to work.'
    end
    text_input attribute, unacceptable
    click_button button_finder

    if page.has_selector? parsley_errors_selector(attribute)
      text_input attribute, acceptable
      if page.has_selector? parsley_errors_selector(attribute)
        @error = "Expected parsley error to clear when attribute
                  '#{attribute}' was set to '#{acceptable}', but it did not.".squish
        false
      else
        true
      end
    else
      @error = "Expected a parsley error when attribute #{attribute} was
                set with value #{unacceptable}, but none was found.".squish
      false
    end
  end

  def parsley_errors_selector(attribute)
    ".#{attribute}_#{subject.class.name.underscore} ul.parsley-errors-list.filled"
  end

  def text_input(name, value)
    input_name = subject.class.name.underscore + "[#{name}]"
    fill_in input_name, with: value
  end

  chain :and_reject, :unacceptable
  chain :with_button, :button_finder

  failure_message do |_attribute|
    @error
  end
end

RSpec.shared_examples 'Stuff All Users Can Do' do
  let(:shipment) { create :shipment }
  before do
    user
    shipment
  end

  def text_input(name, value)
    input_name = subject.class.name.underscore + "[#{name}]"
    fill_in input_name, with: value
  end

  it 'should sign in' do
    sign_in
    expect(page).to have_current_path(root_path)
  end

  describe 'Editing Batches' do
    subject { batch }
    let(:batch) { create :batch_accepted }
    let(:values) { Hashie::Mash.new(values_hash) }
    let(:values_hash) do
      {
        cartons_packed: { acceptable: '1', unacceptable: '0.1' },
        net_weight_sellable: { acceptable: '0.123', unacceptable: '0.01' },
        gross_fresh_primary_ingredient: { acceptable: '0.194', unacceptable: '0.01' },
        amount_of_primary_ingredient: { acceptable: '101', unacceptable: '0.1' },
        harvest_thick: { acceptable: '10.001', unacceptable: '0.01' },
        harvest_thin: { acceptable: '110.001', unacceptable: '0.01' },
        harvest_scraps: { acceptable: '120.05', unacceptable: '0.01' },
        unusable_thick_product: { acceptable: '23.001', unacceptable: '0.01' },
        unusable_thin_product: { acceptable: '423.001', unacceptable: '0.01' },
        unusable_other_product: { acceptable: '123.001', unacceptable: '0.01' }
      }
    end
    it 'should be able to edit the batch' do
      sign_in
      visit edit_batch_path(batch)

      values.each do |attr, vals|
        expect(attr).to accept_value(vals.acceptable)
          .and_reject(vals.unacceptable).with_button('Update Batch')
      end

      click_button 'Update Batch'

      expect(page).not_to have_selector('ul.parsley-errors-list.filled')

      values.each do |attr, vals|
        expect(page).to have_field("batch[#{attr}]", with: vals.acceptable)
      end

      visit batch_path(batch)
      click_button 'More Info'
      values.each do |attr, vals|
        selector = "dt[data-name='#{Batch.human_attribute_name(attr)}'] + dd"
        expect(page).to have_selector(selector, text: vals.acceptable)
      end
    end
  end

  it 'should connect batch to shipment' do
    sign_in
    batch = create(:batch)
    visit(batch_path(batch))
    click_link 'Connect To Shipment'
    expect(page).to have_selector("select[name='batch[shipment_id]']")
    expect(page).to have_selector("option[value='#{shipment.id}']")
    find("option[value='#{shipment.id}']").select_option
    click_button 'Save'
    batch.reload
    # expect(batch.shipment).to eq shipment
    expect(page).to have_link_to(shipment_path(shipment))
  end

  describe 'Accept Button' do
    subject { create :batch_qa }

    describe 'when there is no '

    it 'should ACCEPT batches' do
      sign_in
      batch = subject
      visit(batch_path(batch))

      click_link 'Accept'

      expect(page).to have_selector('.event_modal form')
      text_input :cartons_packed, '123'
      click_button('Yes, Accept')
      expect(page).to have_link('Ship')
    end
  end

  describe 'Finish Button' do
    subject { create :batch_started }

    it 'should create and resolve issues' do
      sign_in
      visit batch_path subject
      click_link('Issue')
      fill_in 'batch[new_issue][problem]', with: 'Problem'
      fill_in 'batch[new_issue][steps_to_correct]', with: 'Steps to correct'
      click_button 'Yes, Issue'
      sleep(1) unless page.has_link?('Resolve')
      expect(page).to have_link('Resolve')
      click_link 'Resolve'
      expect(page).to have_link('Finish')
    end

    it 'should finish batches' do
      sign_in
      batch = subject
      visit(batch_path(batch))
      click_link 'Finish'
      text_input :pouches_produced, '123'
      text_input :net_weight_sellable, '123.45'
      text_input :cartons_packed, '123'
      text_input :unusable_thin_product, '0.1'
      text_input :unusable_thick_product, '0.1'
      text_input :unusable_other_product, '0.1'
      find('.event_modal button[type=submit]').click

      sleep(1) if page.has_selector?('.event_modal')

      expect(page).not_to have_selector('.event_modal')
      expect(page).to have_link('Accept')
    end
  end
end

RSpec.describe 'Basic User Flows:', js: true, type: :feature do
  let(:user) do
    create :user, password: 'foobuckles', role: role, receive_issue_mailings: true
  end
  context 'Supervisor:' do
    it_has_the_behavior_of 'Stuff All Users Can Do' do
      let(:role) { 'supervisor' }
    end
  end

  context 'Manager:' do
    it_has_the_behavior_of 'Stuff All Users Can Do' do
      let(:role) { 'manager' }
    end
  end

  context 'Admin:' do
    it_has_the_behavior_of 'Stuff All Users Can Do' do
      let(:role) { 'admin' }
    end
  end
end
