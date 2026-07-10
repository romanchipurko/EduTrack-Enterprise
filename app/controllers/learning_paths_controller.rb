class LearningPathsController < ApplicationController
  def index
    @learning_paths = LearningPath.all
    @learning_paths = @learning_paths.where("title ILIKE ?", "%#{params[:search]}%") if params[:search].present?
  end

  def show
    @learning_path = LearningPath.find(params[:id])
  end
end
