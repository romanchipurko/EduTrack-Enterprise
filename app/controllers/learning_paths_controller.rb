class LearningPathsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_learning_path, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_learning_path, only: [ :show, :edit, :update, :destroy ]

  def index
    authorize LearningPath
    scope = params[:search].present? ? LearningPath.search_by_content(params[:search]) : LearningPath.all
    @learning_paths = policy_scope(scope).page(params[:page]).per(9)
  end

  def show
    @course_contents = @learning_path.course_contents
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
    @course_contents = @learning_path.course_contents
  end

  def update
    if @learning_path.update(learning_path_params)
      redirect_to edit_learning_path_path(@learning_path), notice: t("learning_path.updated")
    else
      flash.now[:alert] = t("errors.form_check")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @learning_path.destroy
    redirect_to learning_paths_path, notice: t("learning_path.deleted")
  end

  private

  def course_builder_params
    params.require(:course_builder_form).permit(:title, :description, :lesson_title, :quiz_title)
  end

  def learning_path_params
    params.require(:learning_path).permit(:title, :description)
  end

  def set_learning_path
    @learning_path = LearningPath.find(params[:id])
  end

  def authorize_learning_path
    authorize @learning_path
  end
end
