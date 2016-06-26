require 'rails_helper'

RSpec.describe Partner::Backlink, type: :model do
  
  it "has a valid factory" do
    expect(FactoryGirl.create(:partner_backlink)).to be_valid
  end
  it "is valid without status" do
    expect(FactoryGirl.create(:partner_backlink, status: nil)).to be_valid
  end
  it "raises error without a partner" do
    expect{FactoryGirl.create(:partner_backlink, partner: nil)}
    .to raise_error(ActiveRecord::RecordInvalid)
    .with_message(/Partner must exist/)
  end
  it "raises error without a business" do
    expect{FactoryGirl.create(:partner_backlink, business: nil)}
    .to raise_error(ActiveRecord::RecordInvalid)
    .with_message(/Business must exist/)
  end
  it "raises error without an owner" do
    expect{FactoryGirl.create(:partner_backlink, owner: nil)}
    .to raise_error(ActiveRecord::RecordInvalid)
    .with_message(/Owner must exist/)
  end
  it "is valid without a request" do
    expect(FactoryGirl.create(:partner_backlink, request: nil)).to be_valid
  end
  it "raises error when status is not included in enum" do
    expect{FactoryGirl.build(:partner_backlink, status: 'unknown')}
    .to raise_error(ArgumentError)
    .with_message(/is not a valid status/)
  end
  context 'when status is null' do
    let(:backlink) { FactoryGirl.create(:partner_backlink, status: nil, activated_at:nil, deactivated_at: nil) }
    it "lets activated_at unchanged" do
      expect(backlink.activated_at).to be_nil
    end
    it "lets deactivated_at unchanged" do
      expect(backlink.activated_at).to be_nil
    end
    context 'when status is changed to active' do
      it "sets activated_at to now" do
        backlink.active!
        expect(backlink.activated_at.utc.strftime("%c")).to eq(Time.now.utc.strftime("%c"))
      end
    end
    context 'when status is changed to inactive' do
      it "sets deactivated_at to now" do
        backlink.inactive!
        expect(backlink.deactivated_at.utc.strftime("%c")).to eq(Time.now.utc.strftime("%c"))
      end
    end
  end
  context 'when status is active, with an activated_at in the past' do
    let(:backlink) { FactoryGirl.create(:active_partner_backlink) }
    let(:data) { FactoryGirl.create(:data) }
    it "lets activated_at unchanged" do
      backlink.save!
      expect(backlink.activated_at.utc.to_i).to eql(THREEDAYSAGO.to_time.to_i)
    end
  end
  context 'when status is inactive, with an deactivated_at in the past' do
    let(:backlink) { FactoryGirl.create(:inactive_partner_backlink) }
    it "lets activated_at unchanged" do
      backlink.inactive!
      expect(backlink.deactivated_at.utc.to_i).to eq(THREEDAYSAGO.to_time.to_i)
    end
  end
  let(:website) { FactoryGirl.create(:business_website) }
  it "is valid to link to an existing website" do
    expect(FactoryGirl.create(:partner_backlink, website: nil, link: "#{website.url}/path")).to be_valid
  end
  let(:backlink) { FactoryGirl.build(:partner_backlink, website: nil, link: nil) }
  it "is not valid to link to an website which doesnt exit" do
    backlink.link = "http://example.com/path/to"
    expect { backlink.save! }
    .to raise_error(ActiveRecord::RecordInvalid)
    .with_message(/Website can't be blank/)
  end
end
