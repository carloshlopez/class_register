require "application_system_test_case"

class ClassroomRegistersTest < ApplicationSystemTestCase
  setup do
    @classroom_register = classroom_registers(:one)
  end

  test "visiting the index" do
    visit classroom_registers_url
    assert_selector "h1", text: "Classroom Registers"
  end

  test "creating a Classroom register" do
    visit classroom_registers_url
    click_on "New Classroom Register"

    fill_in "Attendees", with: @classroom_register.attendees
    fill_in "Chapter", with: @classroom_register.chapter_id
    fill_in "Description", with: @classroom_register.description
    fill_in "Happened at", with: @classroom_register.happened_at
    fill_in "Teacher", with: @classroom_register.teacher_id
    click_on "Create Classroom register"

    assert_text "Classroom register was successfully created"
    click_on "Back"
  end

  test "updating a Classroom register" do
    visit classroom_registers_url
    click_on "Edit", match: :first

    fill_in "Attendees", with: @classroom_register.attendees
    fill_in "Chapter", with: @classroom_register.chapter_id
    fill_in "Description", with: @classroom_register.description
    fill_in "Happened at", with: @classroom_register.happened_at
    fill_in "Teacher", with: @classroom_register.teacher_id
    click_on "Update Classroom register"

    assert_text "Classroom register was successfully updated"
    click_on "Back"
  end

  test "destroying a Classroom register" do
    visit classroom_registers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Classroom register was successfully destroyed"
  end
end
