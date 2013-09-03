class AddAllAndNoneToNewsletters < ActiveRecord::Migration
  def change
    add_column :newsletters, :all_users, :integer
    add_column :newsletters, :no_degree_programs, :integer
  end
end
