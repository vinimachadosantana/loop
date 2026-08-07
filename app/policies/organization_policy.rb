class OrganizationPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:memberships).where(memberships: { user_id: user.id })
    end
  end

  def create?
    true
  end

  def show?
    membership.present?
  end

  def update?
    membership&.admin?
  end

  def destroy?
    membership&.admin?
  end

  private

  def membership
    @membership ||= record.memberships.find_by(user_id: user.id)
  end
end
