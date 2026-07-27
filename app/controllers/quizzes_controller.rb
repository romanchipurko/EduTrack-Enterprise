class QuizzesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course_content
  before_action :set_quiz, only: [ :show, :edit, :update, :destroy ]

  def show
    @previous_attempts = current_user.quiz_attempts.where(quiz_id: @quiz.id.to_s).order(created_at: :desc)
  end

  def new
    @quiz = @course_content.quizzes.build
    @quiz.questions.build
  end

  def create
    @quiz = @course_content.quizzes.build(quiz_params)

    if @quiz.save
      redirect_to edit_course_content_path(@course_content), notice: t("quizzes.created")
    else
      flash.now[:alert] = t("errors.form_check")
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @quiz.update(quiz_params)
      redirect_to edit_course_content_path(@course_content), notice: t("quizzes.updated")
    else
      flash.now[:alert] = t("errors.form_check")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @quiz.destroy
    redirect_to edit_course_content_path(@course_content), notice: t("quizzes.deleted")
  end

  def submit
    @score = 0
    @total = @quiz.questions.count
    @user_answer = params[:answers] || {}

    @quiz.questions.each do |question|
      @score += 1 if @user_answer[question.id.to_s] == question.correct_answer.to_s
    end

    save_attempt
  end

  private

  def set_course_content
    @course_content = CourseContent.find(params[:course_content_id])
  end

  def set_quiz
    @quiz = @course_content.quizzes.find(params[:id])
  end

  def quiz_params
    params.require(:quiz).permit(
      :title,
      questions_attributes: [
        :id,
        :text,
        :correct_answer,
        :_desctroy,
        options: []
      ]
    )
  end

  def save_attempt
    QuizAttempt.create!(
      user: current_user,
      quiz_id: @quiz.id.to_s,
      score: @score,
      total: @total
    )
  end
end
