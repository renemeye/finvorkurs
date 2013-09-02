class CreateNewsletters < ActiveRecord::Migration
  def change
    create_table :newsletters do |t|
      t.string :subject
      t.text :content
      t.references :author
      t.string :state

      t.timestamps
    end
    add_index :newsletters, :author_id
  end
end
