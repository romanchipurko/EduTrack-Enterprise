require 'rails_helper'

RSpec.describe 'learning_paths/show', type: :view do
  let(:learning_path) { build_stubbed(:learning_path, title: 'Test Path', description: 'Test description') }
  let(:markdown_element) { Elements::Markdown.new(body: 'Hello World', position: 1) }
  let(:enrollment) { build_stubbed(:enrollment, progress_percentage: 50) }

  let(:lesson) do
    CourseContent.new(
      id: BSON::ObjectId.new,
      title: 'Intro to Mongo',
      position: 1,
      elements: [ markdown_element ]
    )
  end

  before do
    assign(:learning_path, learning_path)
    assign(:course_contents, [])
    assign(:enrollment, enrollment)

    allow(view).to receive(:current_user).and_return(nil)
    without_partial_double_verification { allow(view).to receive(:policy).and_return(double(update?: true)) }

    allow(enrollment).to receive(:item_completed?).and_return(false)

    view.controller.default_url_options = { locale: 'en' }
  end

  context 'when user is not enrolled' do
    before do
      assign(:enrollment, nil)
      allow(learning_path).to receive(:course_contents).and_return([ lesson ])
      render
    end

    it 'displays the curriculum locked message' do
      expect(rendered).to have_text(I18n.t('learning_paths.show.curriculum_locked_title'))
    end

    it 'displays the subscribe button' do
      expect(rendered).to have_button(I18n.t('learning_paths.show.subscribe'))
    end
  end

  context 'when user is enrolled and there are no course contents' do
    before do
      allow(learning_path).to receive(:course_contents).and_return([])
      render
    end

    it 'displays the breadcrumb navigation structure' do
      expect(rendered).to have_css('nav[aria-label="breadcrumb"]')
    end

    it 'displays the link to all paths' do
      expect(rendered).to have_link(I18n.t('learning_paths.show.breadcrumb_all'), href: learning_paths_path)
    end

    it 'displays the empty state message' do
      expect(rendered).to have_text(I18n.t('learning_paths.show.no_lessons'))
    end

    it 'displays the current progress' do
      expect(rendered).to have_text('50%')
    end
  end

  context 'when user is enrolled and course contents exist' do
    before do
      allow(lesson).to receive(:quizzes).and_return([])
      allow(learning_path).to receive(:course_contents).and_return([ lesson ])
      assign(:course_contents, [ lesson ])

      render
    end

    it 'renders the curriculum text' do
      expect(rendered).to have_text(I18n.t('learning_paths.show.curriculum'))
    end

    it 'renders the accordion item' do
      expect(rendered).to have_css('.accordion-item')
    end

    it 'renders the lesson title' do
      expect(rendered).to have_text('Intro to Mongo')
    end

    it 'renders the lesson prefix' do
      expect(rendered).to have_text(I18n.t('learning_paths.show.lesson_prefix', number: 1))
    end

    it 'renders the lesson content' do
      expect(rendered).to have_text('Hello World')
    end

    it 'renders the submit and go next button' do
      expect(rendered).to have_button(I18n.t('learning_paths.show.submit_and_go_next'))
    end
  end
end
