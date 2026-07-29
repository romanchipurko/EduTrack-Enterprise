require 'rails_helper'

RSpec.describe 'Admin Dashboard', type: :request do
  let(:admin) { create(:user, :admin) }
  let(:regular_user) { create(:user) }

  describe 'GET /admin/dashboard' do
    context 'when not authenticated' do
      before { get admin_dashboard_path }

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
        get admin_dashboard_path
        expect(response).to have_http_status(:redirect)
      end
    end

    context 'when authenticated as admin' do
      before do
        sign_in admin
        create_list(:user, 3)
        get admin_dashboard_path
      end

      it 'returns HTTP 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'displays new users table' do
        expect(response.body).to include(I18n.t('active_admin.dashboard.new_users_table.new_users'))
      end

      it 'displays overall info' do
        expect(response.body).to include(I18n.t('active_admin.dashboard.overall_info_table.overall'))
      end
    end
  end
end
