require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "GET /" do
    it "return a success status (HTTP 200)" do
      get root_path
      expect(response).to have_http_status(:success)
    end

    it "renders the index template" do
      get root_path
      expect(response.body).to include(I18n.t('home.hero.title'))
    end

    context "when locale switching (I18n) is used" do
      it "sets the default locale if no parameter is passed" do
        get root_path
        expect(response).to have_http_status(:success)
      end

      it "successfully switches locale via url parameters" do
        get root_path(locale: :en)
        expect(response).to have_http_status(:success)
      end
    end
  end
end
