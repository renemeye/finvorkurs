class TestResult < ActiveRecord::Base
  belongs_to :test
  belongs_to :user
  attr_accessible :score

  def message
    "#{self.user.email} finished the test for #{self.test.title} with #{self.score} %"
  end

end
