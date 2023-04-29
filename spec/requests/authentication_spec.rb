require 'rails_helper'

RSpec.describe "Authentications", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/authentication/show"
      expect(response).to have_http_status(:success)
    end
  end

end
