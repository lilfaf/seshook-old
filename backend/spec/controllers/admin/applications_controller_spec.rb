require 'rails_helper'

describe Admin::ApplicationsController do
  let(:admin) { nil }

  before { sign_in admin }

  #context "as an admin" do
  #  let(:admin) { create(:admin) }
  #
  #  it "unauthorize access" do
  #    get :index
  #    expect(response.body).to redirect_to(dashboard_path)
  #  end
  #end

  context "as an admin" do
    let(:admin) { create(:admin) }

    #it 'includes application helper' do
    #  expect(subject.respond_to?(:bootstrap_class_for)).to be(true)
    #end

    it "renders admin layout" do
      get :index
      is_expected.to render_with_layout(:admin)
    end
  end
end
