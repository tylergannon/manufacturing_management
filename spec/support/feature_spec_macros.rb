# frozen_string_literal: true
module FeatureSpecMacros
  extend ActiveSupport::Concern

  def sign_in
    visit root_path
    expect(page).to have_current_path(new_user_session_path)
    fill_in('user[email]', with: user.email)
    fill_in('user[password]', with: 'foobuckles')
    click_button('Log in')
  end

  def have_link_to(href)
    have_selector("a[href='#{href}']")
  end

  def date_select_today(model_name, attribute)
    find("input[name='#{model_name}[#{attribute}]']").click
    click_button 'Today'
  end

  def close_date_select
    click_button 'Close' if page.has_button? 'Close'
  end

  def chosen_select(model_name, attribute, search_text)
    chosen = find("##{model_name}_#{attribute}_chosen")
    chosen.click
    within chosen do
      find('input[type=text]').set search_text
      first('li.active-result').click
    end
  end

  def select_option(selector)
    find(selector).select_option
  end

  def create_batch
    visit root_path
    first(:css, "[href='#{new_batch_path}']").click
    expect(page).to have_current_path new_batch_path

    selector = "select[name='batch[flavor_id]'] option:nth-child(2)"
    find(selector).select_option
    selector = "select[name='batch[shipment_id]'] option:last-child"
    find(selector).select_option
    fill_in('batch[production_date]', with: '2016-10-01')
    fill_in('batch[gross_fresh_primary_ingredient]', with: '100')
    click_button('Create Batch')
    expect(page).not_to have_current_path(new_batch_path)
  end
end
