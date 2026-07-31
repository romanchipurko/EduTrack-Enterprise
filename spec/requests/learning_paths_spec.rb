require 'rails_helper'

RSpec.describe 'LearningPaths', type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user, :admin) }
  let(:learning_path) { create(:learning_path) }

  before do
    sign_in user
  end

  describe 'GET /learning_paths/:id' do
    context 'when user is enrolled and course contents exist' do
      before do
        create(:enrollment, user: user, learning_path: learning_path)
        CourseContent.create!(
          title: 'Intro to Mongo',
          position: 1,
          learning_path_id: learning_path.id.to_s
        )
        get learning_path_path(learning_path, locale: 'en')
      end

      it 'returns a successful response' do
        expect(response).to be_successful
      end

      it 'renders the curriculum headers' do
        expect(response.body).to include(I18n.t('learning_paths.show.curriculum'))
      end

      it 'renders the lesson title' do
        expect(response.body).to include('Intro to Mongo')
      end
    end

    context 'when user is enrolled but no course contents exist' do
      before do
        create(:enrollment, user: user, learning_path: learning_path)
        get learning_path_path(learning_path, locale: 'en')
      end

      it 'returns a successful response' do
        expect(response).to be_successful
      end

      it 'renders the empty state message' do
        expect(response.body).to include(I18n.t('learning_paths.show.no_lessons'))
      end
    end

    context 'when user is not enrolled' do
      before do
        get learning_path_path(learning_path, locale: 'en')
      end

      it 'returns a successful response' do
        expect(response).to be_successful
      end

      it 'renders the curriculum locked message' do
        expect(response.body).to include(I18n.t('learning_paths.show.curriculum_locked_title'))
      end
    end
  end
end
