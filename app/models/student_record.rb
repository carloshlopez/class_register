class StudentRecord < ApplicationRecord
  belongs_to :student
  belongs_to :chapter
end
