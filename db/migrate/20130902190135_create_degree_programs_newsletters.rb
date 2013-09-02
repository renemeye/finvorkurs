class CreateDegreeProgramsNewsletters < ActiveRecord::Migration
  def change
    create_table :degree_programs_newsletters, :id => false do |t|
      t.references :degree_program, :newsletter
    end

    add_index :degree_programs_newsletters, [:degree_program_id, :newsletter_id],
      name: "degree_programs_newsletters_index",
      unique: true
  end
end
