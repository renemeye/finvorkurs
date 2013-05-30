class AddPreregisteredAuthTokenToUser < ActiveRecord::Migration
  def change
		add_column :users, :preregistration_auth_token, :string
		add_column :users, :email_confirmation, :boolean
  end
end
