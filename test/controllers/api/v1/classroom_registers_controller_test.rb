require 'test_helper'

module Api
  module V1
    class ClassroomRegistersControllerTest < ActionDispatch::IntegrationTest
      setup do
        @classroom_register = classroom_registers(:one)
        @chapter = chapters(:one)
        @teacher = teachers(:one)
        @auth_headers = { "Authorization" => "Bearer #{ENV.fetch('HERMES_API_TOKEN')}" }
      end

      test "index requires authentication" do
        get api_v1_classroom_registers_url
        assert_response :unauthorized
      end

      test "index rejects an invalid token" do
        get api_v1_classroom_registers_url, headers: { "Authorization" => "Bearer wrong" }
        assert_response :unauthorized
      end

      test "index returns classroom registers" do
        get api_v1_classroom_registers_url, headers: @auth_headers, as: :json
        assert_response :success

        body = JSON.parse(response.body)
        assert_equal ClassroomRegister.count, body.size
      end

      test "show returns a classroom register" do
        get api_v1_classroom_register_url(@classroom_register), headers: @auth_headers, as: :json
        assert_response :success

        body = JSON.parse(response.body)
        assert_equal @classroom_register.id, body["id"]
      end

      test "show returns not found for a missing classroom register" do
        get api_v1_classroom_register_url(999_999), headers: @auth_headers
        assert_response :not_found
      end

      test "create registers a class and persists who registered it" do
        assert_difference("ClassroomRegister.count") do
          post api_v1_classroom_registers_url,
               params: { classroom_register: {
                 happened_at: @classroom_register.happened_at,
                 attendees: @classroom_register.attendees,
                 description: @classroom_register.description,
                 chapter_id: @chapter.id,
                 teacher_id: @teacher.id,
                 registered_by: "Jane Doe"
               } },
               headers: @auth_headers,
               as: :json
        end

        assert_response :created
        body = JSON.parse(response.body)
        assert_equal "Jane Doe", body["registered_by"]
      end

      test "create rejects requests without a valid token" do
        assert_no_difference("ClassroomRegister.count") do
          post api_v1_classroom_registers_url,
               params: { classroom_register: { chapter_id: @chapter.id, teacher_id: @teacher.id } },
               as: :json
        end

        assert_response :unauthorized
      end

      test "create returns unprocessable_content for a nonexistent chapter" do
        assert_no_difference("ClassroomRegister.count") do
          post api_v1_classroom_registers_url,
               params: { classroom_register: {
                 happened_at: @classroom_register.happened_at,
                 attendees: @classroom_register.attendees,
                 description: @classroom_register.description,
                 chapter_id: 999_999,
                 teacher_id: @teacher.id,
                 registered_by: "Jane Doe"
               } },
               headers: @auth_headers,
               as: :json
        end

        assert_response :unprocessable_content
      end
    end
  end
end
