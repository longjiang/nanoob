require 'rails_helper'

RSpec.describe Business::Website, type: :model do
  it "has a valid factory" do 
    expect(FactoryGirl.create(:business_website)).to be_valid
  end
  it "is invalid without a business" do
    expect(FactoryGirl.build(:business_website, business: nil)).to_not be_valid
  end
  it "is invalid without a platform" do
    expect(FactoryGirl.build(:business_website, platform: nil)).to_not be_valid
  end
  it "is invalid without a url" do
    expect(FactoryGirl.build(:business_website, url: nil)).to_not be_valid
  end
  it "raises error when platform is not included in enum" do
    expect{FactoryGirl.build(:business_website, platform: 'unknown')}
    .to raise_error(ArgumentError)
    .with_message(/is not a valid platform/)
  end
  context 'when URL already exists for a business' do
    let(:business) { FactoryGirl.create :business }
    let(:url) { Faker::Internet.url }
    it "raises error with same url" do
      FactoryGirl.create(:business_website, business: business, url: url)
      expect(FactoryGirl.create(:business_website, business: business, url: url)).to_not be_valid
    end
  end
  context 'when URL already exists for an other business' do
    let(:business1) { FactoryGirl.create :business }
    let(:business2) { FactoryGirl.create :business }
    let(:url) { Faker::Internet.url }
    it "raises error with same url" do
      FactoryGirl.create(:business_website, business: business1, url: url)
      expect(FactoryGirl.create(:business_website, business: business2, url: url)).to_not be_valid
    end
  end
  
end
