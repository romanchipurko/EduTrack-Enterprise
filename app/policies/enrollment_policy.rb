class EnrollmentPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.admin? || record.user_id == user.id
  end

  def create?
    user.present?
  end

  def update?
    user.admin? || record.user_id == user.id
  end

  def destroy?
    user.admin?
  end

  def destroy_all?
    user.admin?
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end
end
