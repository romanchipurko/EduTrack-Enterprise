require 'rails_helper'

RSpec.describe 'Enrollments', type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let(:learning_path) { create(:learning_path) }

  describe 'POST /learning_paths/:learning_path_id/enrollments' do
    context 'when user is not authenticated' do
      it 'redirects to the sign in page' do
        post learning_path_enrollments_path(learning_path)
        expect(response).to redirect_to(new_user_session_path(locale: I18n.default_locale))
      end
    end

    context 'when user is authenticated and subscribing for the first time' do
      before do
        sign_in user
      end

      it 'creates a new enrollment' do
        expect {
          post learning_path_enrollments_path(learning_path)
        }.to change(Enrollment, :count).by(1)
      end

      it 'redirects to the learning path page' do
        post learning_path_enrollments_path(learning_path)
        expect(response).to redirect_to(learning_path_path(learning_path))
      end

      it 'associates the enrollment with the correct user' do
        post learning_path_enrollments_path(learning_path)
        expect(Enrollment.last.user_id).to eq(user.id)
      end

      it 'associates the enrollment with the correct learning path' do
        post learning_path_enrollments_path(learning_path)
        expect(Enrollment.last.learning_path_id).to eq(learning_path.id)
      end
    end

    context 'when authenticated and updating progress without next_item_id' do
      let(:item_id) { BSON::ObjectId.new.to_s }
      let(:enrollment) { create(:enrollment, user: user, learning_path: learning_path) }

      before do
        sign_in user
        enrollment
        CourseContent.create!(title: 'Dummy Lesson', position: 1, learning_path_id: learning_path.id.to_s)
      end

      it 'does not create a duplicate enrollment' do
        expect {
          post learning_path_enrollments_path(learning_path), params: { item_id: item_id }
        }.not_to change(Enrollment, :count)
      end

      it 'adds the item_id to completed_item_ids' do
        post learning_path_enrollments_path(learning_path), params: { item_id: item_id }
        expect(enrollment.reload.completed_item_ids).to include(item_id)
      end

      it 'redirects back to the learning path page' do
        post learning_path_enrollments_path(learning_path), params: { item_id: item_id }
        expect(response).to redirect_to(learning_path_path(learning_path))
      end
    end

    context 'when authenticated and updating progress with next_item_id' do
      let(:item_id) { BSON::ObjectId.new.to_s }
      let(:next_item_id) { BSON::ObjectId.new.to_s }

      before do
        sign_in user
        create(:enrollment, user: user, learning_path: learning_path)
        CourseContent.create!(title: 'Dummy Lesson', position: 1, learning_path_id: learning_path.id.to_s)
      end

      it 'redirects to the learning path with next_item_id query param' do
        post learning_path_enrollments_path(learning_path), params: { item_id: item_id, next_item_id: next_item_id }
        expect(response).to redirect_to(learning_path_path(learning_path, next_item_id: next_item_id))
      end
    end
  end
end
