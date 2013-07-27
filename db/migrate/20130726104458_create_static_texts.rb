class CreateStaticTexts < ActiveRecord::Migration
  def change
    create_table :static_texts do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
    add_index :static_texts, :key
  end
end
