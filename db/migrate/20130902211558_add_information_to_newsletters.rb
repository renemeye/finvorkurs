class AddInformationToNewsletters < ActiveRecord::Migration
  def change
    add_column :newsletters, :delivered_at, :datetime
    add_column :newsletters, :last_receiver_id, :integer
  end
end
