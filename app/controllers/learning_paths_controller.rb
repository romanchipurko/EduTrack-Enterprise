class LearningPathsController < ApplicationController
  before_action :authenticate_user!

  def index
    @learning_paths = LearningPath.all
    @learning_paths = @learning_paths.search_by_content(params[:search]) if params[:search].present?
  end

  def show
    @learning_path = LearningPath.find(params[:id])
  end

  def new
    authorize LearningPath
    @form = CourseBuilderForm.new
  end

  def create
    authorize LearningPath
    @form = CourseBuilderForm.new(course_builder_params)

    if @form.save
      redirect_to learning_path_path(@form.learning_path), notice: t("learning_paths.created_notice")
    else
      flash.now[:alert] = t("errors.form_check")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @learning_path = LearningPath.find(params[:id])
    authorize @learning_path
    @course_contents = CourseContent.where(learning_path_id: @learning_path.id).order_by(position: :asc)
  end

  private

  def course_builder_params
    params.require(:course_builder_form).permit(:title, :description, :lesson_title)
  end
end
