require 'rails_helper'

RSpec.describe AnalyticsEvent, type: :model do
  describe "validations" do
    subject { build(:analytics_event) }

    it { is_expected.to validate_presence_of(:event_type) }
    it { is_expected.to validate_presence_of(:lesson_id) }
    it { is_expected.to validate_presence_of(:payload) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:learning_path) }
  end

  describe "scopes" do
    let(:learning_path) { create(:learning_path) }

    let!(:completion_other_path) do
      create(:analytics_event, event_type: "user.lesson_completed",
             learning_path: create(:learning_path), created_at: Time.current)
    end
    let!(:completion_on_path) do
      create(:analytics_event, event_type: "user.lesson_completed",
             learning_path: learning_path, created_at: 1.day.ago)
    end
    let!(:recent_other_event) do
      create(:analytics_event, event_type: "other.event", created_at: 2.days.ago)
    end
    let!(:old_lesson_completed) do
      create(:analytics_event, event_type: "user.lesson_completed", created_at: 3.days.ago)
    end

    describe ".recent" do
      it "orders by created_at desc" do
        expected = [ completion_other_path, completion_on_path, recent_other_event, old_lesson_completed ]
        expect(described_class.recent.to_a).to eq(expected)
      end
    end

    describe ".by_event" do
      it "filters by event_type" do
        results = described_class.by_event("user.lesson_completed")
        expect(results).to contain_exactly(old_lesson_completed, completion_on_path, completion_other_path)
      end
    end

    describe ".for_path" do
      it "filters by learning_path_id" do
        results = described_class.for_path(learning_path.id)
        expect(results).to contain_exactly(completion_on_path)
      end
    end
  end
end
