class CreateChapters < ActiveRecord::Migration[5.2]
  def change
    create_table :chapters do |t|
      t.string :name
      t.string :country
      t.string :city
      t.date :started_at

      t.timestamps
    end
  end
end
