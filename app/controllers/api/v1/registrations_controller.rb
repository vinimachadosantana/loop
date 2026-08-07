module Api
  module V1
    class RegistrationsController < BaseController
      def create
        user = User.new(registration_params)
        user.save!

        render json: UserSerializer.new(user).serialize, status: :created
      end

      private

      def registration_params
        params.expect(user: [ :email, :name, :password ])
      end
    end
  end
end
