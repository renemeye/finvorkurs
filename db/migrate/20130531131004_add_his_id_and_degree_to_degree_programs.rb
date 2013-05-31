class AddHisIdAndDegreeToDegreePrograms < ActiveRecord::Migration
  def change
		add_column :degree_programs, :his_id, :integer
		add_column :degree_programs, :degree, :string
  end
end
