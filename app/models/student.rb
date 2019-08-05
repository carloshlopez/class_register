class Student < ApplicationRecord
  belongs_to :chapter
  has_many :student_records
end
