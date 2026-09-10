# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_10_153055) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", precision: nil, null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "chapters", force: :cascade do |t|
    t.string "city"
    t.string "country"
    t.datetime "created_at", precision: nil, null: false
    t.string "name"
    t.date "started_at"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "classroom_registers", force: :cascade do |t|
    t.integer "attendees"
    t.bigint "chapter_id"
    t.datetime "created_at", precision: nil, null: false
    t.text "description"
    t.date "happened_at"
    t.string "registered_by"
    t.bigint "teacher_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["chapter_id"], name: "index_classroom_registers_on_chapter_id"
    t.index ["teacher_id"], name: "index_classroom_registers_on_teacher_id"
  end

  create_table "student_records", force: :cascade do |t|
    t.boolean "attended"
    t.bigint "chapter_id"
    t.datetime "created_at", precision: nil, null: false
    t.text "desc"
    t.integer "points"
    t.bigint "student_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["chapter_id"], name: "index_student_records_on_chapter_id"
    t.index ["student_id"], name: "index_student_records_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.date "birth_date"
    t.bigint "chapter_id"
    t.datetime "created_at", precision: nil, null: false
    t.string "name"
    t.integer "points"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["chapter_id"], name: "index_students_on_chapter_id"
  end

  create_table "teachers", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "name"
    t.datetime "updated_at", precision: nil, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "classroom_registers", "chapters"
  add_foreign_key "classroom_registers", "teachers"
  add_foreign_key "student_records", "chapters"
  add_foreign_key "student_records", "students"
  add_foreign_key "students", "chapters"
end
