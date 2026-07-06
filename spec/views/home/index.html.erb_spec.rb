require 'rails_helper'

RSpec.describe "home/index", type: :view do
  before { render }

  describe "Hero section" do
    it "renders the hero section container" do
      expect(rendered).to have_css('section.hero')
    end

    it "renders the primary call-to-action button" do
      expect(rendered).to have_css('.hero-buttons a.btn-primary')
    end

    it "renders the secondary outline button" do
      expect(rendered).to have_css('.hero-buttons a.btn-outline-light')
    end
  end

  describe "Architecture section" do
    it "renders the architecture section container" do
      expect(rendered).to have_css('section#architecture')
    end

    it "renders exactly 5 flow items" do
      expect(rendered).to have_css('.architecture-flow .flow-item', count: 5)
    end

    it "renders exactly 4 flow arrows" do
      expect(rendered).to have_css('.architecture-flow .flow-arrow', count: 4)
    end
  end

  describe "Stack section" do
    it "renders the stack section container" do
      expect(rendered).to have_css('section.stack')
    end

    it "renders the stack grid layout" do
      expect(rendered).to have_css('.stack-grid')
    end

    it "includes Rails 8 in the stack" do
      expect(rendered).to include('Rails 8')
    end

    it "includes PostgreSQL in the stack" do
      expect(rendered).to include('PostgreSQL')
    end

    it "includes MongoDB in the stack" do
      expect(rendered).to include('MongoDB')
    end

    it "includes Redis in the stack" do
      expect(rendered).to include('Redis')
    end

    it "includes RabbitMQ in the stack" do
      expect(rendered).to include('RabbitMQ')
    end
  end

  describe "About section" do
    it "renders the about section container" do
      expect(rendered).to have_css('section.about')
    end

    it "renders the blockquote icon" do
      expect(rendered).to have_css('i.bi-quote')
    end
  end
end
