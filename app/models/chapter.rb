class Chapter < ApplicationRecord
  has_many :students
  has_many :student_records
end
