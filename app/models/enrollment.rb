class Enrollment < ActiveRecord::Base
  attr_accessible :course, :user_id, :score
  belongs_to :user
  belongs_to :course
  belongs_to :group

  STATES = {
    :enrolled => 0,
    :unregistered => 1
  }

  default_scope where(:status => STATES[:enrolled])
  scope :unregistered, where(:status => STATES[:unregistered])
  #scope :for_user, (user) -> where(:user_id => user.id)


  def message
    unregistered = ""
    if self.status == STATES[:unregistered]
      unregistered = "and unregistered #{self.updated_at.strftime("on %d.%m.%Y at %H:%M Uhr")}"
    end

    "#{self.user.name} has enrolled to #{self.course.title} #{unregistered}"
  end

  def to_s
    if self.user.test_results.where('course_id = ?', self.course.id).empty?
      "#{self.user.name} #{self.group}"
    else
      "#{self.user.name} (#{self.user.test_results.where('course_id = ?', self.course.id).first.score}% #{self.group})"
    end
  end

end
