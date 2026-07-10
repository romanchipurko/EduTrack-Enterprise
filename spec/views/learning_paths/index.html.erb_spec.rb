require 'rails_helper'

RSpec.describe 'learning_paths/index', type: :view do
  let(:learning_paths) { build_stubbed_list(:learning_path, 3) }

  before do
    assign(:learning_paths, learning_paths)
    allow(view).to receive(:current_user).and_return(nil)

    view.controller.default_url_options = { locale: 'en' }
    render
  end

  it 'renders the page header with title' do
    expect(rendered).to have_css('h1', text: I18n.t('learning_paths.index.title'))
  end

  it 'renders the page header with subtitle' do
    expect(rendered).to have_css('p.text-muted', text: I18n.t('learning_paths.index.subtitle'))
  end

  it 'renders the search form' do
    expect(rendered).to have_css("form[action='#{learning_paths_path}']")
  end

  it 'renders search field' do
    expect(rendered).to have_field('search')
  end

  it 'renders search button' do
    expect(rendered).to have_css("input[type='submit'][value='#{I18n.t('learning_paths.index.search_button')}']")
  end

  it 'renders the correct number of cards' do
    expect(rendered).to have_css('.learning-path-card', count: 3)
  end

  it 'renders a details link for each learning path' do
    learning_paths.each do |path|
      expect(rendered).to have_link(I18n.t('learning_paths.card.details'), href: learning_path_path(path))
    end
  end

  it 'renders each card with title and description' do
    learning_paths.each do |path|
      expect(rendered).to include(path.title, path.description)
    end
  end

  it 'renders the empty partial when no paths' do
    assign(:learning_paths, [])
    render
    expect(rendered).to render_template(partial: '_empty_page_template')
  end

  it 'displays empty state message' do
    assign(:learning_paths, [])
    render
    expect(rendered).to have_css('h3', text: I18n.t('learning_paths.empty.title'))
  end

  context 'when search results are filtered' do
    let(:filtered_paths) { [ learning_paths.first ] }

    before do
      assign(:learning_paths, filtered_paths)
      render
    end

    it 'includes filtered path content' do
      expect(rendered).to include(filtered_paths.first.title)
    end
  end
end
