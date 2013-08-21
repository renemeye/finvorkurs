class AddVotedAsCorrectToReplies < ActiveRecord::Migration
  def change
    add_column :replies, :voted_as_correct, :boolean
  end
end
