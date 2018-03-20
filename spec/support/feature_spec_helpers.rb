# frozen_string_literal: true
module FeatureSpecHelpers
  def create_basic_data_helpers
    let(:brand) { create :brand, hostname: 'www.example.com', display: 'Foo Bax' }
    let(:member) { create :member, circles: [circle], uid: '9LvzvqeTXN', brand: brand }
    let(:circle) { create :circle, journeys: [journey], name: 'Circle One' }
    let(:journey) { create :journey, modules: [journey_module], topic: 'Foo Baz' }
    let(:journey_module) { create :journey_module, name: 'Foo' }
  end

  def sign_in
    create_basic_data_helpers
    before(:each) do
      set_omniauth(linkedin: { email: member.email })
      visit '/members/sign_in'

      find(:css, '#sign-in .sign-in-button').click
      expect(page).to have_current_path(circle_path(circle))
    end
  end

  def sign_in_and_go_to_module_view
    sign_in
    before(:each) do
      visit circle_path(circle)
      expect(page).to have_current_path(circle_path(circle))
      expect(page).to have_css('.link-to-journeys')
      find(:css, '.link-to-journeys').click
      expect(page).to have_css('.link-to-journey')

      #  Note the use of `.trigger('click')` here.
      #  capybara-webkit (has a problem with glyphicons?)
      #  sees glyphicon links as overlapped by other elements
      #  and won't do a normal click, so we do a javascript
      #  trigger to make it happen.
      find(:css, '.link-to-journey').trigger('click')
      find(:css, '.expand-icon').click
    end
  end
end
