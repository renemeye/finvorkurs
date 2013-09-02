class ConvertStaticTextsValueToText < ActiveRecord::Migration
  def up
  	change_column :static_texts, :value, :text
  end

  def down
  	#Might have problems with texts bigger than 255 chars
	change_column :static_texts, :value, :string
  end
end