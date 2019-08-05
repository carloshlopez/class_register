# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_03_010817) do

  create_table "chapters", force: :cascade do |t|
    t.string "name"
    t.string "country"
    t.string "city"
    t.date "started_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "classroom_registers", force: :cascade do |t|
    t.date "happened_at"
    t.integer "attendees"
    t.text "description"
    t.integer "chapter_id"
    t.integer "teacher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chapter_id"], name: "index_classroom_registers_on_chapter_id"
    t.index ["teacher_id"], name: "index_classroom_registers_on_teacher_id"
  end

  create_table "student_records", force: :cascade do |t|
    t.text "desc"
    t.integer "points"
    t.boolean "attended"
    t.integer "student_id"
    t.integer "chapter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chapter_id"], name: "index_student_records_on_chapter_id"
    t.index ["student_id"], name: "index_student_records_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.date "birth_date"
    t.integer "points"
    t.integer "chapter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chapter_id"], name: "index_students_on_chapter_id"
  end

  create_table "teachers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
