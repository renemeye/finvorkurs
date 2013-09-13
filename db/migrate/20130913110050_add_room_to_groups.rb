class AddRoomToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :room, :string
  end
end
