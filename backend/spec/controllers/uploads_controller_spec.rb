require 'rails_helper'

describe S3Relay::UploadsController do
  routes { S3Relay::Engine.routes }

  let(:error) { {error: I18n.t('devise.failure.unauthenticated')}.to_json }

  describe '#GET new' do
    context 'user not signed in' do
      it 'restrict access' do
        get :new, format: :json
        expect(response.status).to eq(401)
        expect(response.body).to be_json_eql(error)
      end
    end

    context 'user signed in through devise' do
      before { sign_in current_user }

      it 'render signed url as json' do
        get :new, format: :json
        expect(response.status).to eq(200)
        expect(response.body).to have_json_type(Hash)
      end
    end

    context 'user signed in through doorkeeper' do
      it 'render signed url as json' do
        get :new, access_token: oauth_token, format: :json
        expect(response.status).to eq(200)
        expect(response.body).to have_json_type(Hash)
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
        expect(response.body).to be_json_eql(error)
      end
    end

    context 'user signed in through devise' do
      before { sign_in current_user }

      it 'creates upload' do
        post :create, attributes
        expect(response.status).to eq(201)
        expect(response.body).to have_json_path('private_url')
      end
    end

    context 'user signed in through doorkeeper' do
      it 'creates upload' do
        post :create, attributes.merge(access_token: oauth_token), format: :json
        expect(response.status).to eq(201)
        expect(response.body).to have_json_path('private_url')
      end
    end
  end
end
