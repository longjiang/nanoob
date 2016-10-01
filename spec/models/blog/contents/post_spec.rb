require 'rails_helper'

RSpec.describe Blog::Contents::Post, type: :model do
  it "has a valid factory" do 
    expect(FactoryGirl.create(:post)).to be_valid
  end
end
