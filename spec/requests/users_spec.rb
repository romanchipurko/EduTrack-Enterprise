# spec/requests/users_spec.rb
require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { create(:user) }

  let(:profile_url) { profile_path(locale: 'en') }
  let(:new_session_url) { new_user_session_path(locale: 'en') }

  describe 'GET /profile' do
    context 'when user is not authenticated' do
      it 'redirects to sign in page' do
        get profile_url
        expect(response).to redirect_to(new_session_url)
      end
    end

    context 'when user is authenticated' do
      before { sign_in user }

      it 'returns http success' do
        get profile_url
        expect(response).to have_http_status(:success)
      end

      it 'renders the show template' do
        get profile_url
        expect(response).to render_template(:show)
      end

      it 'assigns @user as current_user' do
        get profile_url
        expect(assigns(:user)).to eq(user)
      end
    end
  end
end
