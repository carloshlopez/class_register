class ClassroomRegister < ApplicationRecord
  belongs_to :chapter
  belongs_to :teacher
  has_one_attached :audio
  has_many_attached :images
end
