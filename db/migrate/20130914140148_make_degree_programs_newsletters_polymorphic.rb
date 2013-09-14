class MakeDegreeProgramsNewslettersPolymorphic < ActiveRecord::Migration
  def up
  	rename_table :degree_programs_newsletters, :newsletter_maps

  	rename_column :newsletter_maps, :degree_program_id, :receiver_group_id
  	add_column :newsletter_maps, :receiver_group_type, :string
  	NewsletterMap.reset_column_information
  	NewsletterMap.update_all(:receiver_group_type => "DegreeProgram")

  end

  def down
	raise ActiveRecord::IrreversibleMigration, "Would have to delete data."
  end
end
