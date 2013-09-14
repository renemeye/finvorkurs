class AddIndexToNewsletterMaps < ActiveRecord::Migration
  def change
    add_index :newsletter_maps, [:receiver_group_id, :receiver_group_type], :name => "index_newsletter_maps_on_receiver_group_id_and_type"
  end
end
