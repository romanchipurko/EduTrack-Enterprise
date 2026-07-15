class UserPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    user.admin? || user == record
  end

  def create?
    user.admin?
  end

  def update?
    user.admin? || ( user == record && !record.admin? )
  end

  def destroy?
    user.admin? || user == record
  end

  def change_role?
    user.admin? && user != record
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(id: user.id)
      end
    end
  end  
end
