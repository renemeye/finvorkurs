class CreateDegreeProgramsUsers < ActiveRecord::Migration
  def up
		create_table :degree_programs_users do |t|
			  t.references :user
				t.references :degree_program
		end
  end

  def down
		drop_table :degree_programs_users
  end
end
