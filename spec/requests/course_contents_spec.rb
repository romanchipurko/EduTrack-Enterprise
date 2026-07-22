require 'rails_helper'

RSpec.describe 'CourseContents', type: :request do
  let(:user) { create(:user, :instructor) }
  let(:learning_path) { create(:learning_path) }
  let!(:course_content) do
    CourseContent.create!(
      learning_path_id: learning_path.id.to_s,
      title: 'Original Title',
      position: 1
    )
  end

  before { sign_in user }

  describe 'GET /course_contents/:id/edit' do
    it 'renders the edit template successfully' do
      get edit_course_content_path(course_content, locale: 'en')
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PATCH /course_contents/:id' do
    let(:update_params) do
      {
        course_content: {
          title: 'Updated Lesson Title',
          position: 1,
          elements_attributes: [ { _type: 'Elements::Markdown', position: 1, body: 'Hello' } ]
        }
      }
    end

    before do
      patch course_content_path(course_content, locale: 'en'), params: update_params
      course_content.reload
    end

    it 'redirects to edit page' do
      expect(response).to redirect_to(edit_course_content_path(course_content, locale: 'en'))
    end

    it 'updates the lesson title' do
      expect(course_content.title).to eq('Updated Lesson Title')
    end

    it 'creates embedded elements' do
      expect(course_content.elements.first).to be_a(Elements::Markdown)
    end
  end

  describe 'DELETE /course_contents/:id' do
    it 'deletes the lesson' do
      expect {
        delete course_content_path(course_content, locale: 'en')
      }.to change(CourseContent, :count).by(-1)
    end

    it 'redirects to learning path editor' do
      delete course_content_path(course_content, locale: 'en')
      expect(response).to redirect_to(edit_learning_path_path(learning_path.id, locale: 'en'))
    end
  end
end
