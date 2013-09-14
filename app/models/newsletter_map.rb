class NewsletterMap < ActiveRecord::Base
  belongs_to :newsletter
  belongs_to :receiver_group, :polymorphic => true
end