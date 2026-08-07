module Api
  module V1
    class BaseController < ApplicationController
      include Authentication

      rescue_from StandardError, with: :internal_server_error
      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActionController::ParameterMissing, with: :bad_request
      rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity

      private

      def render_error(code:, message:, status:, details: {})
        render json: { error: { code:, message:, details: } }, status:
      end

      def not_found(_error)
        render_error(code: "not_found", message: "Resource not found", status: :not_found)
      end

      def bad_request(error)
        render_error(code: "bad_request", message: error.message, status: :bad_request)
      end

      def unprocessable_entity(error)
        render_error(
          code: "validation_failed",
          message: "Validation failed",
          status: :unprocessable_entity,
          details: error.record.errors.to_hash
        )
      end

      def internal_server_error(error)
        Rails.logger.error("#{error.class}: #{error.message}")
        Rails.logger.error(error.backtrace&.first(10)&.join("\n"))
        raise error if Rails.env.local?

        render_error(code: "internal_error", message: "Something went wrong", status: :internal_server_error)
      end
    end
  end
end
