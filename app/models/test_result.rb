class TestResult < ActiveRecord::Base
  belongs_to :vorkurs_test
  belongs_to :user
  attr_accessible :score

  def message
    "#{self.user.email} finished the test for #{self.vorkurs_test.title} with #{self.score} %"
  end

end
