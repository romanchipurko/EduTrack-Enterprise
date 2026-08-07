require 'rails_helper'

RSpec.describe 'quizzes/new', type: :view do
  let(:course_content) { build_stubbed(:course_content, id: '123', learning_path_id: '456') }
  let(:quiz) { build(:quiz, course_content: course_content) }

  before do
    quiz.questions.build
    assign(:course_content, course_content)
    assign(:quiz, quiz)
    view.controller.default_url_options = { locale: 'en' }
    render
  end

  it 'renders the new quiz form' do
    expect(rendered).to have_css('form')
  end

  it 'displays the correct title' do
    expect(rendered).to have_css('h2', text: I18n.t('quizzes.new.title'))
  end

  it 'contains the title input field' do
    expect(rendered).to have_field('quiz[title]')
  end
end
