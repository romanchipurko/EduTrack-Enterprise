require 'rails_helper'

RSpec.describe "Analytics", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:admin) { create(:user, :admin) }
  let(:instructor) { create(:user, :instructor) }
  let(:learning_path) { create(:learning_path) }

  describe "GET /analytics" do
    context "when user is not authenticated" do
      it "redirects to the sign in page" do
        get analytics_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is authenticated as instructor" do
      before { sign_in instructor }

      it "allows access and renders index template" do
        get analytics_path
        expect(response).to have_http_status(:ok)
      end

      it "caches @completions_by_day via Rails.cache.fetch" do
        allow(Rails.cache).to receive(:fetch).and_call_original

        get analytics_path

        expect(Rails.cache).to have_received(:fetch).with("analytics/lesson_completed_7_days", expires_in: 5.minutes)
      end

      it "caches @top_paths via Rails.cache.fetch" do
        allow(Rails.cache).to receive(:fetch).and_call_original

        get analytics_path

        expect(Rails.cache).to have_received(:fetch).with("analytics/top_paths", expires_in: 5.minutes)
      end
    end

    context "when instructor and there are completion events in the last 7 days" do
      before do
        sign_in instructor
        create(:analytics_event, event_type: "user.lesson_completed",
               created_at: 2.days.ago, learning_path: learning_path)
        create(:analytics_event, event_type: "user.lesson_completed",
               created_at: 2.days.ago, learning_path: learning_path)
        get analytics_path
      end

      it "returns a Hash for @completions_by_day" do
        expect(assigns(:completions_by_day)).to be_a(Hash)
      end

      it "includes the correct date in @completions_by_day" do
        expect(assigns(:completions_by_day).keys).to include(2.days.ago.to_date)
      end

      it "counts completions correctly in @completions_by_day" do
        expect(assigns(:completions_by_day).values.sum).to eq(2)
      end
    end

    context "when instructor and there are completions for multiple learning paths" do
      let(:other_path) { create(:learning_path) }

      before do
        sign_in instructor
        create(:analytics_event, event_type: "user.lesson_completed", learning_path: learning_path)
        create(:analytics_event, event_type: "user.lesson_completed", learning_path: learning_path)
        create(:analytics_event, event_type: "user.lesson_completed", learning_path: other_path)
        get analytics_path
      end

      it "returns a Hash for @top_paths" do
        expect(assigns(:top_paths)).to be_a(Hash)
      end

      it "counts completions per learning path" do
        expect(assigns(:top_paths)[learning_path.id]).to eq(2)
      end

      it "sums all completions across paths" do
        expect(assigns(:top_paths).values.sum).to eq(3)
      end
    end

    context "when instructor and there are more than 10 recent events" do
      before do
        sign_in instructor
        15.times { create(:analytics_event) }
        get analytics_path
      end

      it "limits @recent_events to 10 records" do
        expect(assigns(:recent_events).size).to eq(10)
      end

      it "orders @recent_events from newest to oldest" do
        recent = assigns(:recent_events)
        expect(recent.first.created_at).to be >= recent.last.created_at
      end
    end

    context "when user is authenticated as admin" do
      before { sign_in admin }

      it "allows access" do
        get analytics_path
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
