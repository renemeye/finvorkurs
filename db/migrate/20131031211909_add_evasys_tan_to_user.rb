class AddEvasysTanToUser < ActiveRecord::Migration
  def change
    add_column :users, :evasys_tan, :string
  end
end
