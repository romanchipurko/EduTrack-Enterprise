class AnalyticsEventPolicy < ApplicationPolicy
  def index?
    user.instructor? || user.admin?
  end

  def show?
    user.instructor? || user.admin?
  end

  def destroy?
    user.admin?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin? || user.instructor?
        scope.all
      else
        scope.none
      end
    end
  end
end
