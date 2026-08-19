class LearningPathPolicy < ApplicationPolicy
  def index?
    user.admin? || user.instructor?
  end

  def show?
    true
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
      scope.all
    end
  end
end
