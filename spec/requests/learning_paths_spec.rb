require 'rails_helper'

RSpec.describe 'LearningPaths', type: :request do
  let!(:rails_path) { create(:learning_path, title: 'Ruby on Rails', description: 'Web development') }
  let!(:python_path) { create(:learning_path, title: 'Python for Data Science', description: 'Data analysis') }

  describe 'GET /index' do
    it 'returns http success' do
      get learning_paths_path(locale: 'en')
      expect(response).to have_http_status(:ok)
    end

    it 'renders index template' do
      get learning_paths_path(locale: 'en')
      expect(response).to render_template(:index)
    end

    it 'displays all learning path titles' do
      get learning_paths_path(locale: 'en')
      expect(response.body).to include(rails_path.title, python_path.title)
    end

    it 'displays all learning path descriptions' do
      get learning_paths_path(locale: 'en')
      expect(response.body).to include(rails_path.description, python_path.description)
    end

    context 'when searching' do
      it 'filters learning paths by title' do
        get learning_paths_path(locale: 'en', search: 'Rails')
        expect(response.body).to include(rails_path.title)
      end

      it 'shows empty state when no results found' do
        get learning_paths_path(locale: 'en', search: 'NonExistent')
        expect(response.body).to include(I18n.t('learning_paths.empty.title'))
      end
    end

    context 'when locale is Russian' do
      it 'displays translated titles' do
        I18n.with_locale(:ru) do
          get learning_paths_path(locale: 'ru')
          expect(response.body).to include(I18n.t('learning_paths.index.title', locale: :ru))
        end
      end
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      get learning_path_path(rails_path, locale: 'en')
      expect(response).to have_http_status(:ok)
    end

    it 'renders show template' do
      get learning_path_path(rails_path, locale: 'en')
      expect(response).to render_template(:show)
    end

    it 'displays learning path title and description' do
      get learning_path_path(rails_path, locale: 'en')
      expect(response.body).to include(rails_path.title, rails_path.description)
    end

    it 'displays back link' do
      get learning_path_path(rails_path, locale: 'en')
      expect(response.body).to include(I18n.t('learning_paths.show.back_to_list'))
    end

    it 'displays breadcrumb link' do
      get learning_path_path(rails_path, locale: 'en')
      expect(response.body).to include(I18n.t('learning_paths.show.breadcrumb_all'))
    end

    context 'when record not found' do
      it 'returns 404 not found' do
        get learning_path_path(id: 'non-existent', locale: 'en')
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
