require 'test_helper'

class ClassroomRegistersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @classroom_register = classroom_registers(:one)
  end

  test "should get index" do
    get classroom_registers_url
    assert_response :success
  end

  test "should get new" do
    get new_classroom_register_url
    assert_response :success
  end

  test "should create classroom_register" do
    assert_difference('ClassroomRegister.count') do
      post classroom_registers_url, params: { classroom_register: { attendees: @classroom_register.attendees, chapter_id: @classroom_register.chapter_id, description: @classroom_register.description, happened_at: @classroom_register.happened_at, teacher_id: @classroom_register.teacher_id } }
    end

    assert_redirected_to classroom_register_url(ClassroomRegister.last)
  end

  test "should show classroom_register" do
    get classroom_register_url(@classroom_register)
    assert_response :success
  end

  test "should get edit" do
    get edit_classroom_register_url(@classroom_register)
    assert_response :success
  end

  test "should update classroom_register" do
    patch classroom_register_url(@classroom_register), params: { classroom_register: { attendees: @classroom_register.attendees, chapter_id: @classroom_register.chapter_id, description: @classroom_register.description, happened_at: @classroom_register.happened_at, teacher_id: @classroom_register.teacher_id } }
    assert_redirected_to classroom_register_url(@classroom_register)
  end

  test "should destroy classroom_register" do
    assert_difference('ClassroomRegister.count', -1) do
      delete classroom_register_url(@classroom_register)
    end

    assert_redirected_to classroom_registers_url
  end
end
