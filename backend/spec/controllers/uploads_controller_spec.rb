require 'rails_helper'

describe S3Relay::UploadsController do
  routes { S3Relay::Engine.routes }

  let(:error) { {error: I18n.t('devise.failure.unauthenticated')} }

  describe '#GET new' do
    context 'user not signed in' do
      it 'restrict access' do
        get :new, format: :json
        expect(response.status).to eq(401)
        expect(json_response).to eq(error)
      end
    end

    context 'user signed in through devise' do
      before { sign_in current_user }

      it 'render signed url as json' do
        get :new, format: :json
        expect(response.status).to eq(200)
        expect(json_response).to be_a(Hash)
      end
    end

    context 'user signed in through doorkeeper' do
      it 'render signed url as json' do
        api_get :new
        expect(response.status).to eq(200)
        expect(json_response).to be_a(Hash)
      end
    end
  end

  describe '#POST create' do
    let(:upload) { create(:upload) }
    let(:attributes) {
      attributes_for(:photo_upload).merge(association: 'PhotoUpload')
    }

    context 'user not signed in' do
      it 'restrict access' do
        post :create, format: :json
        expect(response.status).to eq(401)
        expect(json_response).to eq(error)
      end
    end

    context 'user signed in through devise' do
      before { sign_in current_user }

      it 'creates upload' do
        post :create, attributes
        expect(response.status).to eq(201)
        expect(json_response[:private_url]).to match(/amazonaws.com/)
      end
    end

    context 'user signed in through doorkeeper' do
      it 'creates upload' do
        post :create, attributes.merge(access_token: oauth_token), format: :json
        expect(response.status).to eq(201)
        expect(json_response[:private_url]).to match(/amazonaws.com/)
      end
    end
  end
end
