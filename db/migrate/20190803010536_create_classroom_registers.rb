class CreateClassroomRegisters < ActiveRecord::Migration[5.2]
  def change
    create_table :classroom_registers do |t|
      t.date :happened_at
      t.integer :attendees
      t.text :description
      t.references :chapter, foreign_key: true
      t.references :teacher, foreign_key: true

      t.timestamps
    end
  end
end
