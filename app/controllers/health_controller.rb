class HealthController < ApplicationController
  def show
    render json: {
      status: "ok",
      database: database_connected? ? "ok" : "error",
      time: Time.current.iso8601
    }
  end

  private

  def database_connected?
    ActiveRecord::Base.connection.active?
  rescue StandardError
    false
  end
end
