class CourseContentPolicy < ApplicationPolicy
  extend Forwardable

  def_delegators :learning_path_policy, :show?, :create?, :update?, :destroy?

  def index?
    user.admin? || user.instructor?
  end

  private

  def learning_path_policy
    @learning_path_policy ||= LearningPathPolicy.new(user, postgres_learning_path)
  end

  def postgres_learning_path
    @postgres_learning_path ||= LearningPath.find_by(id: record.learning_path_id)
  end

  class Scope < Scope
    def resolve
      return scope.all if user.admin? || user.instructor?

      scope.none
    end
  end
end
