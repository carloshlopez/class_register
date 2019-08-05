class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students do |t|
      t.string :name
      t.date :birth_date
      t.integer :points
      t.references :chapter, foreign_key: true

      t.timestamps
    end
  end
end
