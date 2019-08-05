json.extract! student, :id, :name, :birth_date, :points, :chapter_id, :created_at, :updated_at
json.url student_url(student, format: :json)
