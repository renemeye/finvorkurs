class Newsletter < ActiveRecord::Base
  has_and_belongs_to_many :degree_programs
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id', :validate => true
  attr_accessible :content, :state, :subject, :author_id

  def sent?
  	:state == "sent"
  end


end
