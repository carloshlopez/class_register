json.extract! student_record, :id, :desc, :points, :attended, :student_id, :created_at, :updated_at
json.url student_record_url(student_record, format: :json)
