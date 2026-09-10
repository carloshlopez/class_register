module Api
  module V1
    class BaseController < ActionController::API
      before_action :authenticate_hermes!

      rescue_from ActiveRecord::RecordNotFound do
        render json: { error: "Not found" }, status: :not_found
      end

      rescue_from ActiveRecord::InvalidForeignKey do
        render json: { error: "Invalid chapter_id or teacher_id" }, status: :unprocessable_content
      end

      private

      def authenticate_hermes!
        token = request.headers["Authorization"].to_s.delete_prefix("Bearer ")
        expected_token = ENV["HERMES_API_TOKEN"]

        if expected_token.blank? || !ActiveSupport::SecurityUtils.secure_compare(token, expected_token)
          render json: { error: "Unauthorized" }, status: :unauthorized
        end
      end
    end
  end
end
