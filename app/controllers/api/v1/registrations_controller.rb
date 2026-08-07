module Api
  module V1
    class RegistrationsController < BaseController
      allow_unauthenticated_access

      def create
        user = User.new(registration_params)
        user.save!

        session = user.sessions.create!(ip_address: request.remote_ip, user_agent: request.user_agent)
        render json: { token: session.token, user: UserSerializer.new(user).as_json }, status: :created
      end

      private

      def registration_params
        params.expect(user: [ :email, :name, :password ])
      end
    end
  end
end
