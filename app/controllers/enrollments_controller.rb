class EnrollmentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @learning_path = LearningPath.find(params[:learning_path_id])
    @enrollment = current_user.enrollments.find_or_create_by(learning_path: @learning_path)

    authorize @enrollment

    @enrollment.complete_item!(item_id: params[:item_id]) if params[:item_id].present?

    if params[:next_item_url].present?
      redirect_to params[:next_item_url]
    else
      redirect_to learning_path_path(@learning_path)
    end
  end
end
