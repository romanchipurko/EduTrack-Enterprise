require 'rails_helper'

RSpec.describe 'learning_paths/show', type: :view do
  let(:learning_path) { create(:learning_path, title: 'Test Path', description: 'Test description') }

  before do
    assign(:learning_path, learning_path)
    allow(view).to receive(:current_user).and_return(nil)

    view.controller.default_url_options = { locale: 'en' }
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

  context 'when description is blank' do
    let(:learning_path) { build_stubbed(:learning_path, title: 'Test Path', description: nil) }

    it 'shows empty description paragraph' do
      expect(rendered).to have_css('p.text-muted', text: '')
    end
  end
end
