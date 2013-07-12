class Question < ActiveRecord::Base
  belongs_to :test
  has_many :answers
  attr_accessible :text, :test_id

  def previous
    self.class.last :order => 'id', :conditions => ['id < ?', self.id]
  end

  def next
    self.class.first :order => 'id', :conditions => ['id > ?', self.id]
  end
end
