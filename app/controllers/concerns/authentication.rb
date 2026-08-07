module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private

  def require_authentication
    Current.session = find_session_by_bearer_token
    return if Current.session

    render_error(code: "unauthorized", message: "Authentication required", status: :unauthorized)
  end

  def find_session_by_bearer_token
    token = request.headers["Authorization"]&.split(" ")&.last
    return if token.blank?

    session = Session.includes(:user).find_by(token: token)
    session unless session.nil? || session.expired?
  end

  def current_user
    Current.user
  end
end
