require 'rails_helper'

RSpec.describe 'quizzes/show', type: :view do
  let(:course_content) { CourseContent.new(title: 'Lesson 1', learning_path_id: 'abc') }
  let(:question) { Question.new(text: 'What is 2+2?', options: [ '3', '4' ], correct_answer: 1) }
  let(:quiz) { Quiz.new(title: 'Sample Quiz', course_content_id: '123') }

  before do
    # Идеальный трюк для обхода UrlGenerationError в Rails:
    # Заставляем объекты отдавать роутеру обычные строки
    allow(course_content).to receive(:to_param).and_return('cc_123')
    allow(question).to receive_messages(to_param: 'qst_123', id: 'qst_123')

    allow(quiz).to receive_messages(to_param: 'q_123', questions: [ question ])

    assign(:course_content, course_content)
    assign(:quiz, quiz)
    view.controller.default_url_options = { locale: 'en' }
  end

  context 'when viewing the quiz before submission (wizard)' do
    before { render }

    it 'displays the quiz title' do
      expect(rendered).to have_css('h2', text: 'Sample Quiz')
    end

    it 'renders the question text' do
      expect(rendered).to have_text('What is 2+2?')
    end

    it 'renders the submit button' do
      expect(rendered).to have_button(I18n.t('quizzes.wizard.submit'))
    end
  end

  context 'when viewing the quiz after submission (results)' do
    before do
      assign(:score, 1)
      assign(:total, 1)
      assign(:user_answer, { 'qst_123' => '1' })
      render
    end

    it 'displays the perfect score message if all answers are correct' do
      expect(rendered).to have_text(I18n.t('quizzes.results.perfect_score'))
    end

    it 'displays the retry button' do
      expect(rendered).to have_link(I18n.t('quizzes.results.retry'))
    end
  end
end
