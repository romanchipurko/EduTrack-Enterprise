class AnalyticsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_analytic!

  def index
    @completions_by_day = Rails.cache.fetch("analytics/lesson_completed_7_days", expires_in: 1.hour) do
      AnalyticsEvent.where(event_type: "user.lesson_completed").where("created_at >= ?", 7.days.ago)
                    .group_by_day(:created_at).size
    end

    @top_paths = Rails.cache.fetch("analytics/top_paths", expires_in: 1.hour) do
      AnalyticsEvent.where(event_type: "user.lesson_completed").group(:learning_path_id)
                    .order("count_all DESC").limit(5).size
    end

    @recent_events = AnalyticsEvent.includes(:user, :learning_path).order(created_at: :desc).limit(10)
  end

  private

  def authorize_analytic!
    authorize AnalyticsEvent
  end
end
