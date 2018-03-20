# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'shipments/new', type: :view do
  before(:each) do
    assign(:shipment, (build :shipment))
  end

  it 'renders new shipment form' do
    render

    assert_select 'form[action=?][method=?]', shipments_path, 'post' do
      assert_select 'input#shipment_ships_on[name=?]', 'shipment[ships_on]'
    end
  end
end
