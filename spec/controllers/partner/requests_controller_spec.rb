require 'rails_helper'

RSpec.describe Partner::RequestsController, type: :controller do
  
  login_user
  
  let(:requests) { FactoryGirl.create_list(:partner_request, 4) } 
  
  describe '#index' do
    before(:each) { get :index } 
    it 'assigns all requests to @requests' do
      expect(assigns(:requests)).to match_array requests
    end
    it 'success' do
      expect(response).to be_success
    end
  end

  describe '#create' do
    #before(:each) { post :create, ** request_attrs }
    before(:each) { process :create, method: :post, params: {partner_request: request_attrs} }
    context 'when valid' do
      let(:request_attrs) { FactoryGirl.attributes_for(:partner_request) }
      it 'success' do
        expect(response).to be_success
      end
      it 'saves and assigns new request to @request' do
        request = assigns(:request)
        expect(request).to be_kind_of ActiveRecord::Base
        #expect(request).to be_persisted
        expect(requests).not_to include request
      end
    end
  end
end
