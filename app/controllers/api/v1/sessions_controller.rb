module Api
  module V1
    class SessionsController < BaseController
      allow_unauthenticated_access only: [ :create ]
      skip_after_action :verify_authorized

      def create
        user = User.authenticate_by(email: session_params[:email].to_s.downcase.strip,
                                    password: session_params[:password])

        unless user
          return render_error(code: "invalid_credentials",
                              message: "Invalid email or password",
                              status: :unauthorized)
        end

        session = user.sessions.create!(ip_address: request.remote_ip, user_agent: request.user_agent)

        render json: { token: session.token, user: UserSerializer.new(user).as_json }, status: :created
      end

      def destroy
        Current.session.destroy!
        head :no_content
      end

      private

      def session_params
        params.expect(session: [ :email, :password ])
      end
    end
  end
end
