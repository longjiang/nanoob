require 'rails_helper'

RSpec.describe BusinessesController, type: :controller do
  
  login_user
  
  let(:businesses) { FactoryGirl.create_list(:business, 4) } 
  
  describe '#index' do
    before(:each) { get :index }
    it 'success' do
      expect(response).to be_success
    end
    it 'assigns all businesses to @businesses' do
      expect(assigns(:businesses)).to match_array businesses
    end
  end
  
  context 'when requested business exists' do
    let(:business) { businesses[rand 4] }
    before(:each) { process :show, method: :get, params: { id: business.id } }
    it 'success' do
      expect(response).to be_success
    end
    it 'assigns it to @business' do
      expect(assigns(:business)).to eq business
    end

  end
end
