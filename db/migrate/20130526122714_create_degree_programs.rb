class CreateDegreePrograms < ActiveRecord::Migration
  def change
    create_table :degree_programs do |t|
      t.string :name
      t.references :faculty

      t.timestamps
    end
    add_index :degree_programs, :faculty_id
  end
end
