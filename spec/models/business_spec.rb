require 'rails_helper'

RSpec.describe Business, type: :model do
  it "has a valid factory" do 
    expect(FactoryGirl.create(:business)).to be_valid
  end
  it "is invalid without a name" do
    expect(FactoryGirl.build(:business, name: nil)).to_not be_valid
  end
  it "is invalid without a product" do
    expect(FactoryGirl.build(:business, product: nil)).to_not be_valid
  end
  it "is invalid without a language" do
    expect(FactoryGirl.build(:business, language: nil)).to_not be_valid
  end
  it "raises error when language is not included in enum" do
    expect{FactoryGirl.build(:business, language: 'unknown')}
    .to raise_error(ArgumentError)
    .with_message(/is not a valid language/)
  end
end
