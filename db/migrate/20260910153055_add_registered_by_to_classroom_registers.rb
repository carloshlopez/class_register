class AddRegisteredByToClassroomRegisters < ActiveRecord::Migration[8.1]
  def change
    add_column :classroom_registers, :registered_by, :string
  end
end
