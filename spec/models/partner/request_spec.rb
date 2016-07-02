require 'rails_helper'

RSpec.describe Partner::Request, type: :model do
  
  let(:email_partner)   { FactoryGirl.create(:partner, webform_url: nil) }
  let(:webform_partner) { FactoryGirl.create(:partner, contact_name: nil, contact_email: nil) }
  let(:partner_without_name) { FactoryGirl.create(:partner, contact_name: nil) }
  let(:partner_without_email) { FactoryGirl.create(:partner, contact_email: nil) }
  
  it "has a valid factory" do
    expect(FactoryGirl.create(:partner_request)).to be_valid
  end
  it "is valid without a channel" do
    expect(FactoryGirl.build(:partner_request, channel: nil)).to be_valid
  end
  it "is valid without a subject" do
    expect(FactoryGirl.build(:partner_request, subject: nil)).to be_valid
  end
  it "is valid without a body" do
    expect(FactoryGirl.build(:partner_request, body: nil)).to be_valid
  end
  it "is not valid without a state" do
    expect(FactoryGirl.build(:partner_request, state: nil)).to_not be_valid
  end
  it "raises error when channel is not included in enum" do
    expect{FactoryGirl.build(:partner_request, channel: 'unknown')}
    .to raise_error(ArgumentError)
    .with_message(/is not a valid channel/)
  end
  it "raises error when state is not included in enum" do
    expect{FactoryGirl.build(:partner_request, state: 'unknown')}
    .to raise_error(ArgumentError)
    .with_message(/is not a valid state/)
  end
  it "raises error without a partner" do
    expect{FactoryGirl.create(:partner_request, partner: nil)}
    .to raise_error(ActiveRecord::RecordInvalid)
    .with_message(/Partner must exist/)
  end
  it "raises error without a business" do
    expect{FactoryGirl.create(:partner_request, business: nil)}
    .to raise_error(ActiveRecord::RecordInvalid)
    .with_message(/Business must exist/)
  end
  it "raises error without an owner" do
    expect{FactoryGirl.create(:partner_request, owner: nil)}
    .to raise_error(ActiveRecord::RecordInvalid)
    .with_message(/Owner must exist/)
  end
  it "raises error without an updater" do
    expect{FactoryGirl.create(:partner_request, updater: nil)}
    .to raise_error(ActiveRecord::RecordInvalid)
    .with_message(/Updater must exist/)
  end
  context 'when state_updated_at is nil' do
    let(:request) { FactoryGirl.create(:partner_request, state_updated_at: nil) }
    it "sets state_updated_at to now" do
      expect(request.state_updated_at.utc.strftime("%c")).to eq(Time.now.utc.strftime("%c"))
    end
  end
  context 'when state_updated_at is not nil' do
    let(:date) { DateTime.new(2016, 06, 01, 22, 30, 10) }
    let(:request) { FactoryGirl.create(:partner_request, state_updated_at: date) }
    it "let state_updated_at unchanged" do
      expect(request.state_updated_at.utc.strftime("%c")).to eq(date.utc.strftime("%c"))
    end
  end
  context 'when state is draft' do
    context 'for a webform request' do
      context 'when partner is valid (webform)' do
        before(:each) do
          @request = FactoryGirl.create(:webform_partner_request, partner: webform_partner, state: :draft)
          @request.send_request
        end
        it "updates the state to sent" do
          expect(@request.sent?).to be true
        end
        it "updates the state_updated_at to now" do
          expect(@request.state_updated_at.utc.strftime("%c")).to eq(Time.now.utc.strftime("%c"))
        end
      end
      context 'when partner is not valid (webform_url is missing)' do
        before(:each) do
          @request = FactoryGirl.create(:webform_partner_request, partner: email_partner, state: :draft)
        end
        it "raises an AASM::InvalidTransition Exception" do
          expect{@request.send_request}
          .to raise_error(AASM::InvalidTransition)
          .with_message(/Event 'send_request' cannot transition from 'draft'/)
        end
      end
    end
    
    context 'for an email request' do
      context 'when partner is valid (email and name)' do
        before(:each) do
          @request = FactoryGirl.create(:email_partner_request, partner: email_partner, state: :draft)
          @request.send_request
        end
        it "updates the state to sent" do
          expect(@request.sent?).to be true
        end
        it "updates the state_updated_at to now" do
          expect(@request.state_updated_at.utc.strftime("%c")).to eq(Time.now.utc.strftime("%c"))
        end
      end
      context 'when partner is not valid (email and/or name is missing)' do
        %w(webform_partner partner_without_name partner_without_email).each do |partner|
          before(:each) do
            @request = FactoryGirl.create(:email_partner_request, partner: send(partner), state: :draft)
          end
          it "raises an AASM::InvalidTransition Exception (#{partner})" do
            expect{@request.send_request}
            .to raise_error(AASM::InvalidTransition)
            .with_message(/Event 'send_request' cannot transition from 'draft'/)
          end
        end
      end
    end
  end
      
end
