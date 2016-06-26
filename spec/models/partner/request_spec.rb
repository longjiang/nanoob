require 'rails_helper'

RSpec.describe Partner::Request, type: :model do
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

end
