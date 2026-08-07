module Api
  module V1
    class OrganizationsController < BaseController
      def index
        organizations = policy_scope(Organization)
        render json: OrganizationSerializer.new(organizations).serialize, status: :ok
      end

      def create
        authorize Organization

        organization = nil
        ActiveRecord::Base.transaction do
          organization = Organization.create!(organization_params)
          organization.memberships.create!(user: current_user, role: :admin)
        end

        render json: OrganizationSerializer.new(organization).serialize, status: :created
      end

      def show
        organization = policy_scope(Organization).find(params[:id])
        authorize organization
        render json: OrganizationSerializer.new(organization).serialize, status: :ok
      end

      private

      def organization_params
        params.expect(organization: [ :name ])
      end
    end
  end
end
