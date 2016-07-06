require 'rails_helper'

RSpec.describe Business::Product, type: :model do
  it "has a valid factory" do 
    expect(FactoryGirl.create(:business_product)).to be_valid
  end
  it "is invalid without a name" do
    expect(FactoryGirl.build(:business_product, name: nil)).to_not be_valid
  end  
end
