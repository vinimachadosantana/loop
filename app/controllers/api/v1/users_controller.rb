module Api
  module V1
    class UsersController < BaseController
      def show
        user = User.find(params[:id])
        render json: UserSerializer.new(user).serialize, status: :ok
      end
    end
  end
end
