require 'rails_helper'

RSpec.describe Partner, type: :model do
  it "has a valid factory" do 
    expect(FactoryGirl.create(:partner)).to be_valid
  end
  it "is not valid without a title" do
    expect(FactoryGirl.build(:partner, title: nil)).to_not be_valid
  end
  it "is not valid without an owner" do
    expect(FactoryGirl.build(:partner, owner: nil)).to_not be_valid
  end
  it "is not valid without a category" do
    expect(FactoryGirl.build(:partner, category: nil)).to_not be_valid
  end
  it "raises error when category is not included in enum" do
    expect{FactoryGirl.build(:partner, category: 'unknown')}
    .to raise_error(ArgumentError)
    .with_message(/is not a valid category/)
  end
  it "is not valid without a url" do
    expect(FactoryGirl.build(:partner, url: nil)).to_not be_valid
  end
  it "is valid without a contact_email" do
    expect(FactoryGirl.build(:partner, contact_email: nil)).to be_valid
  end
  it "is valid with an empty email" do
    expect(FactoryGirl.build(:partner, contact_email: "")).to be_valid
  end
  %w( user@example.com fn.ln@e.com fn.ln@a.b.com ).each do |email|
    it "is valid with a properly formatted email" do
      expect(FactoryGirl.build(:partner, contact_email: email)).to be_valid
    end
  end
  %w( user a@a.b ).each do |email|
    it "is not valid with a badly formatted email" do
      expect(FactoryGirl.build(:partner, contact_email: email)).to_not be_valid
    end
  end
  it "is valid without an webform_url" do
    expect(FactoryGirl.build(:partner, webform_url: nil)).to be_valid
  end
  it "is valid with an empty webform_url" do
    expect(FactoryGirl.build(:partner, webform_url: "")).to be_valid
  end
  %w( http://domain.tld https://domain.tld http://domain.tld/my/path http://domain.tld/my/path.html ).each do |url|
    it "is valid with a properly formatted webform_url" do
      expect(FactoryGirl.build(:partner, webform_url: url)).to be_valid
    end
  end
  %w( path example.com example.com/my/path ).each do |url|
    it "is not valid with a badly formatted webform_url" do
      expect(FactoryGirl.build(:partner, webform_url: url)).to_not be_valid
    end
  end
  %w( http://domain.tld https://domain.tld http://domain.tld/my/path http://domain.tld/my/path.html ).each do |url|
    it "is valid with a properly formatted url" do
      expect(FactoryGirl.build(:partner, url: url)).to be_valid
    end
  end
  %w( path example.com example.com/my/path ).each do |url|
    it "is not valid with a badly formatted url" do
      expect(FactoryGirl.build(:partner, url: url)).to_not be_valid
    end
  end
  context "counter cache" do 
    #let!(:partner) { FactoryGirl.create(:partner) }
    let(:count)   { rand(3)+3 }
    before(:each) do
      @partner = FactoryGirl.create(:partner)
      count.times do
        FactoryGirl.create(:partner_request, partner: @partner)
        FactoryGirl.create(:partner_backlink, partner: @partner)
      end
    end
    it "increments requests_count" do
      expect(@partner.requests_count).to eql(count)
    end
    it "increments backlinks_count" do
      expect(@partner.backlinks_count).to eql(count)
    end
    it "decrements requests_count" do
      expect{Partner::Request.all.sample.destroy}.to change{@partner.reload.requests_count}.by(-1)
    end
    it "decrements backlinks_count" do
      expect{Partner::Backlink.all.sample.destroy}.to change{@partner.reload.backlinks_count}.by(-1)
    end
  end
end
