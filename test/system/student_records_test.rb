require "application_system_test_case"

class StudentRecordsTest < ApplicationSystemTestCase
  setup do
    @student_record = student_records(:one)
  end

  test "visiting the index" do
    visit student_records_url
    assert_selector "h1", text: "Student Records"
  end

  test "creating a Student record" do
    visit student_records_url
    click_on "New Student Record"

    check "Attended" if @student_record.attended
    fill_in "Desc", with: @student_record.desc
    fill_in "Points", with: @student_record.points
    fill_in "Student", with: @student_record.student_id
    click_on "Create Student record"

    assert_text "Student record was successfully created"
    click_on "Back"
  end

  test "updating a Student record" do
    visit student_records_url
    click_on "Edit", match: :first

    check "Attended" if @student_record.attended
    fill_in "Desc", with: @student_record.desc
    fill_in "Points", with: @student_record.points
    fill_in "Student", with: @student_record.student_id
    click_on "Update Student record"

    assert_text "Student record was successfully updated"
    click_on "Back"
  end

  test "destroying a Student record" do
    visit student_records_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Student record was successfully destroyed"
  end
end
