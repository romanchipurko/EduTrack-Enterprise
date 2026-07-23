require 'rails_helper'

RSpec.describe 'Admin Learning Paths', type: :request do
  let(:admin) { create(:user, :admin) }
  let(:instructor) { create(:user, :instructor) }
  let(:regular_user) { create(:user) }

  describe 'GET /admin/learning_paths' do
    context 'when not authenticated' do
      before { get admin_learning_paths_path }

      it 'redirects to login page' do
        expect(response).to have_http_status(:redirect)
      end

      it 'redirects to sign in page' do
        expect(response.location).to include(new_user_session_path)
      end
    end

    context 'when authenticated as regular user' do
      before do
        sign_in regular_user
        get admin_learning_paths_path
      end

      it 'redirects' do
        expect(response).to have_http_status(:redirect)
      end
    end

    context 'when authenticated as instructor' do
      before do
        sign_in instructor
        create_list(:learning_path, 2)
        get admin_learning_paths_path
      end

      it 'returns HTTP 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'displays learning paths page' do
        expect(response.body).to include(
          I18n.t('active_admin.learning_paths.title')
        )
      end
    end

    context 'when authenticated as admin' do
      before do
        sign_in admin
        create_list(:learning_path, 2)
        get admin_learning_paths_path
      end

      it 'returns HTTP 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'displays learning paths page' do
        expect(response.body).to include(
          I18n.t('active_admin.learning_paths.title')
        )
      end
    end
  end
end
