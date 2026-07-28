require 'rails_helper'

RSpec.describe 'quizzes/edit', type: :view do
  let(:course_content) { build_stubbed(:course_content, id: '123', learning_path_id: '456') }
  let(:quiz) { build_stubbed(:quiz, :with_questions, title: 'Test Quiz', course_content: course_content) }

  before do
    assign(:course_content, course_content)
    assign(:quiz, quiz)
    view.controller.default_url_options = { locale: 'en' }
    render
  end

  it 'renders the edit quiz form' do
    expect(rendered).to have_css('form')
  end

  it 'displays the correct title' do
    expect(rendered).to have_css('h2', text: I18n.t('quizzes.edit.title'))
  end

  it 'pre-fills the title field' do
    expect(rendered).to have_field('quiz[title]', with: 'Test Quiz')
  end
end
