class CreateStudentRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :student_records do |t|
      t.text :desc
      t.integer :points
      t.boolean :attended
      t.references :student, foreign_key: true
      t.references :chapter, foreign_key: true

      t.timestamps
    end
  end
end
