class CourseContentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course_content, only: [ :edit, :update, :destroy ]
  before_action :authorize_learning_path!, only: [ :edit, :update, :destroy ]

  def edit; end

  def update
    if @course_content.update(course_content_params)
      redirect_to edit_course_content_path(@course_content), notice: t("course_content.updated")
    else
      flash.now[:alert] = t("errors.form_check")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    learning_path_id = @course_content.learning_path_id
    @course_content.destroy
    redirect_to edit_learning_path_path(learning_path_id), notice: t("course_content.deleted")
  end

  private

  def set_course_content
    @course_content = CourseContent.find(params[:id])
  end

  def authorize_learning_path!
    learning_path = @course_content.learning_path
    authorize learning_path, policy_class: LearningPathPolicy
  end

  def course_content_params
    params.require(:course_content).permit(
      :title, :position,
      elements_attributes: [ :id, :_type, :position, :url, :body, :language, :content, :_destroy ]
    ).tap do |_params|
      sanitize_params(elements_attributes: _params[:elements_attributes])
    end
  end

  def sanitize_params(elements_attributes:)
    return if elements_attributes.blank?

    iterable_attributes = elements_attributes.respond_to?(:values) ? elements_attributes.values : elements_attributes
    iterable_attributes.each do |value|
      next if value[:_type].blank?

      value.delete(:_type) unless Elements::Base::ALLOWED_TYPES.include?(value[:_type])
    end
  end
end
