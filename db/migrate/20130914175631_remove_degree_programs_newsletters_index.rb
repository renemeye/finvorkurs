class RemoveDegreeProgramsNewslettersIndex < ActiveRecord::Migration
  def up
  	remove_index :newsletter_maps, :name => "degree_programs_newsletters_index"
  end

  def down
  end
end
