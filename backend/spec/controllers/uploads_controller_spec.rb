require 'rails_helper'

describe UploadsController do
  describe 'GET new' do
    it 'return presigned data' do
      get :new
      content = parse_json(response.body)
      expect(response.status).to eq(200)
      expect(content).to be_a(Hash)
      expect(content).to have_key('uuid')
      expect(content).to have_key('url')
    end
  end
end
