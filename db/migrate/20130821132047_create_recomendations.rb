class CreateRecomendations < ActiveRecord::Migration
  def change
    create_table :recomendations do |t|
      t.integer :min_percentage
      t.string :course_level
      t.references :vorkurs_test

      t.timestamps
    end
    add_index :recomendations, :course_level
    add_index :recomendations, :vorkurs_test_id
  end
end
