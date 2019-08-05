require 'test_helper'

class StudentRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @student_record = student_records(:one)
  end

  test "should get index" do
    get student_records_url
    assert_response :success
  end

  test "should get new" do
    get new_student_record_url
    assert_response :success
  end

  test "should create student_record" do
    assert_difference('StudentRecord.count') do
      post student_records_url, params: { student_record: { attended: @student_record.attended, desc: @student_record.desc, points: @student_record.points, student_id: @student_record.student_id } }
    end

    assert_redirected_to student_record_url(StudentRecord.last)
  end

  test "should show student_record" do
    get student_record_url(@student_record)
    assert_response :success
  end

  test "should get edit" do
    get edit_student_record_url(@student_record)
    assert_response :success
  end

  test "should update student_record" do
    patch student_record_url(@student_record), params: { student_record: { attended: @student_record.attended, desc: @student_record.desc, points: @student_record.points, student_id: @student_record.student_id } }
    assert_redirected_to student_record_url(@student_record)
  end

  test "should destroy student_record" do
    assert_difference('StudentRecord.count', -1) do
      delete student_record_url(@student_record)
    end

    assert_redirected_to student_records_url
  end
end
