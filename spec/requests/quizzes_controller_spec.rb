require 'rails_helper'

RSpec.describe 'Quizzes', type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user, :admin) }
  let(:learning_path) { create(:learning_path) }

  let(:course_content) do
    CourseContent.create!(title: 'Lesson 1', position: 1, learning_path_id: learning_path.id.to_s)
  end

  let(:quiz) do
    q = course_content.quizzes.build(title: 'Test Quiz')
    q.questions.build(text: 'Q1', options: [ 'A', 'B' ], correct_answer: 0)
    q.save!
    q
  end

  before do
    sign_in user
  end

  describe 'GET /show' do
    it 'returns a successful response' do
      get course_content_quiz_path(course_content, quiz, locale: 'en')
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'returns a successful response' do
      get new_course_content_quiz_path(course_content, locale: 'en')
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'when saving is successful' do
      let(:valid_params) do
        { title: 'New Quiz', questions_attributes: { '0' => { text: 'Q2', correct_answer: '1', options: [ 'A', 'B' ] } } }
      end

      it 'redirects to the course content edit page' do
        post course_content_quizzes_path(course_content, locale: 'en'), params: { quiz: valid_params }
        expect(response).to redirect_to(edit_course_content_path(course_content))
      end
    end

    context 'when saving fails' do
      it 'returns unprocessable content' do
        post course_content_quizzes_path(course_content, locale: 'en'), params: { quiz: { title: '' } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'PATCH /update' do
    context 'when update is successful' do
      it 'redirects to the course content edit page' do
        patch course_content_quiz_path(course_content, quiz, locale: 'en'), params: { quiz: { title: 'Updated' } }
        expect(response).to redirect_to(edit_course_content_path(course_content))
      end
    end

    context 'when update fails' do
      it 'returns unprocessable content' do
        patch course_content_quiz_path(course_content, quiz, locale: 'en'), params: { quiz: { title: '' } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'redirects to the course content edit page' do
      delete course_content_quiz_path(course_content, quiz, locale: 'en')
      expect(response).to redirect_to(edit_course_content_path(course_content))
    end
  end

  describe 'POST /submit' do
    before do
      question = quiz.questions.first
      answers = { question.id.to_s => question.correct_answer.to_s }
      post submit_course_content_quiz_path(course_content, quiz, locale: 'en'), params: { answers: answers }
    end

    it 'returns a successful response' do
      expect(response).to be_successful
    end

    it 'renders the perfect score message' do
      expect(response.body).to include(I18n.t('quizzes.results.perfect_score'))
    end
  end
end
