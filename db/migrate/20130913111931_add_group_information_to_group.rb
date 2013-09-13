class AddGroupInformationToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :group_information, :text
  end
end
