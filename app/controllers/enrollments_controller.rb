class EnrollmentsController < ApplicationController
  before_action :authenticate_user!

  def create
    authorize Enrollment
    @learning_path = LearningPath.find(params[:learning_path_id])
    @enrollment = current_user.enrollments.find_or_create_by(learning_path: @learning_path)
    @enrollment.complete_item!(item_id: params[:item_id]) if params[:item_id].present?

    if params[:next_item_id].present?
      redirect_to learning_path_path(@learning_path, next_item_id: params[:next_item_id])
    else
      redirect_to learning_path_path(@learning_path)
    end
  end
end
