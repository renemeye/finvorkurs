class ConvertVorkursTestsDescriptionsToText < ActiveRecord::Migration
  def up
		change_column :vorkurs_tests, :description, :text
  end

  def down
		#Might have problems with texts bigger than 255 chars
		change_column :vorkurs_tests, :description, :string
  end
end
