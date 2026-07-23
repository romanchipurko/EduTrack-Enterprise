class LearningPathPolicy < ApplicationPolicy
  def index?
    user.admin? || user.instructor?
  end

  def show?
    user.admin? || user.instructor?
  end

  def create?
    user.admin? || user.instructor?
  end

  def update?
    user.admin? || user.instructor?
  end

  def destroy?
    user.admin? || user.instructor?
  end

  class Scope < Scope
    def resolve
      return scope.all if user.admin? || user.instructor?

      scope.none
    end
  end
end
