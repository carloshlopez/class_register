json.extract! classroom_register, :id, :happened_at, :attendees, :description, :chapter_id, :teacher_id, :created_at, :updated_at
json.url classroom_register_url(classroom_register, format: :json)
