require 'rails_helper'

RSpec.describe 'learning_paths/show', type: :view do
  let(:learning_path) { create(:learning_path, title: 'Test Path', description: 'Test description') }
  let(:markdown_element) { Elements::Markdown.new(body: 'Hello World', position: 1) }

  let(:lesson) do
    CourseContent.new(
      id: '5f8d04b3e5a5a12345678900',
      title: 'Intro to Mongo',
      position: 1,
      elements: [ markdown_element ]
    )
  end

  before do
    assign(:learning_path, learning_path)
    allow(view).to receive(:current_user).and_return(nil)
    without_partial_double_verification { allow(view).to receive(:policy).and_return(double(update?: true)) }
    view.controller.default_url_options = { locale: 'en' }
  end

  context 'when there are no course contents' do
    before do
      allow(learning_path).to receive(:course_contents).and_return([])
      render
    end

    it 'displays the breadcrumb navigation' do
      aggregate_failures do
        expect(rendered).to have_css('nav[aria-label="breadcrumb"]')
        expect(rendered).to have_link(I18n.t('learning_paths.show.breadcrumb_all'), href: learning_paths_path)
        expect(rendered).to have_css('.breadcrumb-item.active', text: learning_path.title)
      end
    end

    it 'displays the learning path title and description' do
      aggregate_failures do
        expect(rendered).to have_css('h1', text: learning_path.title)
        expect(rendered).to have_css('p.text-muted', text: learning_path.description)
      end
    end

    it 'renders the "Back to list" button' do
      aggregate_failures do
        expect(rendered).to have_link(I18n.t('learning_paths.show.back_to_list'), href: learning_paths_path)
        expect(rendered).to have_css('a.btn-outline-secondary')
      end
    end

    it 'displays the empty state message' do
      expect(rendered).to have_text(I18n.t('learning_paths.show.no_lessons'))
    end
  end

  context 'when description is blank' do
    let(:learning_path) { build_stubbed(:learning_path, title: 'Test Path', description: nil) }

    before do
      allow(learning_path).to receive(:course_contents).and_return([])
      render
    end

    it 'shows empty description paragraph' do
      expect(rendered).to have_css('p.text-muted', text: '')
    end
  end

  context 'when course contents exist' do
    before do
      allow(learning_path).to receive(:course_contents).and_return([ lesson ])
      render
    end

    it 'renders the curriculum headers' do
      aggregate_failures do
        expect(rendered).to have_text(I18n.t('learning_paths.show.curriculum'))
        expect(rendered).to have_css('.accordion-item')
      end
    end

    it 'renders the lesson details' do
      aggregate_failures do
        expect(rendered).to have_text('Intro to Mongo')
        expect(rendered).to have_text(I18n.t('learning_paths.show.lesson_prefix', number: 1))
        expect(rendered).to have_css('.markdown-body', text: 'Hello World')
      end
    end
  end
end
