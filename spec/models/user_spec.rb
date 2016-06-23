require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do 
    expect(FactoryGirl.create(:user)).to be_valid
  end
  it "is invalid without a username" do
    expect(FactoryGirl.build(:user, username: nil)).to_not be_valid
  end
  it "is invalid without an email" do
    expect(FactoryGirl.build(:user, email: nil)).to_not be_valid
  end
  it "is invalid without a password" do
    expect(FactoryGirl.build(:user, password: nil)).to_not be_valid
  end
end
