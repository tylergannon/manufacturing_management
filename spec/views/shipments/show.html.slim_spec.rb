# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'shipments/show', type: :view do
  before(:each) do
    include BootstrapHtmlHelper
    @shipment = assign(:shipment, create(:shipment))
  end
  helper_class.send :include, BootstrapHtmlHelper

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Cancel this shipment and release all associated product./)
  end
end
