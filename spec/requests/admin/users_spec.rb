require 'rails_helper'

RSpec.describe 'Admin Users', type: :request do
  let(:admin) { create(:user, :admin) }
  let(:regular_user) { create(:user) }

  describe 'GET /admin/users' do
    context 'when not authenticated' do
      before { get admin_users_path }

      it 'redirects to login page' do
        expect(response).to have_http_status(:redirect)
      end

      it 'icnlude new user session' do
        expect(response.location).to include(new_user_session_path)
      end
    end

    context 'when authenticated as non-admin' do
      before { sign_in regular_user }

      it 'redirects with an alert' do
        get admin_users_path
        expect(response).to have_http_status(:redirect)
      end
    end

    context 'when authenticated as admin' do
      before do
        sign_in admin
        create_list(:user, 2)
        get admin_users_path
      end

      it 'returns HTTP 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'displays the users table' do
        expect(response.body).to include(I18n.t('active_admin.users.title'))
      end
    end
  end
end
