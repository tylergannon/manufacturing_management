# frozen_string_literal: true
require 'rails_helper'

RSpec::Matchers.define :have_an_issue do
  match(&:issue?)

  failure_message do
    'Expected batch to have an issue.'
  end
  failure_message_when_negated do
    'Expected batch not to have an issue.'
  end
end

RSpec.describe Batch, type: :model do
  before do
    # create :google_calendar
  end

  subject { create :batch, recipe: create(:recipe_flavor3) }

  describe 'Coding printer setting' do
    subject { batch.coding_printer_setting }
    context 'when the shipment is not set' do
      let(:batch) { create :batch }
      it { is_expected.to be_nil }
    end
    context 'when the shipment has been set' do
      let(:batch) { create :batch_with_shipment }
      it { is_expected.not_to be_nil }
    end
  end

  describe 'validations' do
    subject { build :batch, recipe: create(:recipe_flavor3) }

    it { is_expected.to validate_presence_of(:recipe) }
    it { is_expected.to validate_presence_of(:production_date) }

    describe '#can_transition?' do
      describe 'when the transition is invalid' do
        it 'should be false' do
          expect(subject.gross_fresh_primary_ingredient).to be_nil
          subject.start!
          expect(subject.can_transition?(:start)).to be_falsey
        end
      end

      describe 'when the transition is valid' do
        it 'should be true' do
          subject.gross_fresh_primary_ingredient = 12.3
          subject.build_shipment
          expect(subject.can_transition?(:start)).to be_truthy
        end
      end
    end
  end

  describe 'Shipping' do
    describe 'When shipment is shipped' do
      let(:batch) do
        create :batch_accepted
      end
      let(:shipment) do
        shipment = build :shipment_shipped, workflow_state: 'shipped', batches: [batch]
        allow(shipment).to receive(:packing_list?).and_return(true)
        allow(shipment).to receive(:commercial_invoice?).and_return(true)
        shipment.save
        shipment
      end

      it 'should be able to ship' do
        shipment
        batch.ship!
        expect(batch).to be_valid
      end
    end

    describe 'When shipment is not shipped' do
      let(:shipment) { create :shipment, workflow_state: 'scheduled' }
      it 'should not be able to ship' do
        batch = create :batch_accepted, shipment: shipment
        batch.ship!
        expect(batch).not_to be_valid
      end
    end
  end

  let(:user) { create :user, role: 'manager' }

  describe '#batch_number' do
    it 'should be the flavor abbreviation plus the base-24-ified primary key' do
      VCR.use_cassette 'Saving New Cal Event' do
        expect(subject.batch_number).to eq(subject.calculate_slug)
      end
    end
  end

  describe 'Gcal Events' do
    around do |block|
      Rails.application.config.x.gcal_integration_enabled = true
      block.call
      Rails.application.config.x.gcal_integration_enabled = false
    end

    describe 'saving gcal events' do
      describe 'when creating a new batch' do
        subject { build :batch, recipe: create(:recipe_flavor3) }
        it 'should create a gcal event' do
          expect(SaveGcalEventJob).to receive(:perform_later).and_call_flavor1
          VCR.use_cassette 'Saving New Cal Event' do
            expect(subject.gcal_event).not_to be_present
            subject.save!
          end
          expect(subject.gcal_event).to be_present
          # expect(subject.gcal_event.event_id).to be_present
        end
      end
    end

    describe 'updating gcal events' do
      subject { create :batch }
      describe 'When the event is not :cancel' do
        before do
          VCR.use_cassette 'NEW Batches/New Batch To Request Confirmation' do
            subject
          end
          expect(subject.gcal_event).to be_present
        end

        # it "should again post the gcal_event after firing an event." do
        #   expect(SaveGcalEventJob).to receive(:perform_later).and_call_flavor1
        #   VCR.use_cassette "NEW Batches/Existing Batch, Requesting Confirmation" do
        #     subject.start!
        #   end
        # end
      end

      describe 'When CANCELLING the batch' do
        before do
          VCR.use_cassette 'Batches/New Batch To Cancel' do
            subject
          end
          expect(subject.gcal_event).to be_present
          subject.reload
          expect(subject.gcal_event.event_id).to be_present
        end

        # it "should again post the gcal_event after firing an event." do
        #   expect(DeleteGcalEventJob).to receive(:perform_later).and_call_flavor1
        #   VCR.use_cassette "Batches/Existing Batch, Cancelling" do
        #     subject.cancel!
        #   end
        #   subject.reload
        #   expect(subject.gcal_event).not_to be_present
        # end
      end
    end
  end

  describe 'workflow' do
    describe 'validations' do
      subject { create :batch_with_shipment }

      describe 'transitioning from scheduled' do
        describe 'when gross fresh primary_ingredient is present but not persisted' do
          it 'should pass the transition' do
            VCR.use_cassette('Saving New Cal Event') do
              subject.start!
            end
            expect(subject).to be_started
          end
          it 'should persist attributes passed to it with the method.' do
            VCR.use_cassette('Saving New Cal Event') do
              subject.gross_fresh_primary_ingredient = 12.999
              subject.start! model_params: { gross_fresh_primary_ingredient: '12.999' }
            end
            subject.reload
            expect(subject).to be_started
            expect(subject.gross_fresh_primary_ingredient).to eq(12.999)
          end
          it 'does not persist changes given before the event itself.' do
            VCR.use_cassette('Saving New Cal Event') do
              subject.gross_fresh_primary_ingredient = 12.999
              subject.start!
            end
            subject.reload
            expect(subject).to be_started
            expect(subject.gross_fresh_primary_ingredient).not_to eq(12.999)
          end
          it 'loses changes made before the state transition!!!' do
            VCR.use_cassette('Saving New Cal Event') do
              subject.gross_fresh_primary_ingredient = 112.999
              expect(subject).to be_gross_fresh_primary_ingredient_changed
              subject.freeze
              subject.start!
              expect(subject).to be_started
            end
            subject.reload
            expect(subject.gross_fresh_primary_ingredient).not_to eq(12.999)
          end
        end

        describe 'Rejecting' do
          subject { create :batch_started }
          it 'should nullify the shipment' do
            expect(subject.shipment).not_to be_nil
            subject.reject!
            expect(subject).to be_rejected
            expect(subject.shipment).to be_nil
            subject.reload
            expect(subject.shipment).to be_nil
          end
        end

        describe 'Cancelling' do
          subject { create :batch_with_shipment, workflow_state: 'scheduled' }
          it 'should nullify the shipment' do
            expect(subject.shipment).not_to be_nil
            subject.cancel!
            expect(subject).to be_cancelled
            reload = Batch.find_by_friendly!(subject.batch_number)
            expect(reload).not_to be_nil
            expect(subject.shipment).to be_nil
            subject.reload
            expect(subject.shipment).to be_nil
          end
        end

        describe 'when the args are passed to the event' do
          it 'should pass the transition' do
            VCR.use_cassette('Saving New Cal Event') do
              subject.start! model_params: { gross_fresh_primary_ingredient: 32.123 }
            end
            expect(subject).to be_started
            subject.reload
            expect(subject.gross_fresh_primary_ingredient).to eq(32.123)
          end
        end

        describe 'resolve issue' do
          subject { create :batch_started }
          let(:user) { create :user }
          it 'will return to :started state' do
            subject.issue!(requested_by: user, model_params: {
                             new_issue: {
                               problem: 'Foo Problem',
                               steps_to_correct: 'Foo Steps'
                             }
                           })
            expect(subject).to be_inquest
            expect(subject).to have_an_issue
            subject.resolve!(user)
            expect(subject).to be_started
            expect(subject).not_to have_an_issue
          end
        end

        let(:user) { create :user }
        let(:new_batch_log) { BatchLog.last }

        it 'should create a batch log' do
          args = { model_params: { gross_fresh_primary_ingredient: 12.1234 } }
          expect do
            VCR.use_cassette 'Saving New Cal Event' do
              subject.start! requested_by: user, **args
            end
          end.to change(BatchLog, :count).by(1)
          expect(new_batch_log.batch).to eq(subject)
          expect(new_batch_log.approved_by).to eq(user)
          expect(new_batch_log.action).to eq('start')
        end

        describe 'when gross fresh primary_ingredient is absent' do
          it 'should fail the transition' do
            expect(subject.start!(model_params: { gross_fresh_primary_ingredient: nil })).to be_falsey
            expect(subject).to be_scheduled
            expect(subject.errors).to have_key(:gross_fresh_primary_ingredient)
          end
        end
      end
    end
  end
end
