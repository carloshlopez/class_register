class ClassroomRegister < ApplicationRecord
  belongs_to :chapter
  belongs_to :teacher
end
