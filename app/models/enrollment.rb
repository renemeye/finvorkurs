class Enrollment < ActiveRecord::Base
  attr_accessible :course, :user_id, :score
  belongs_to :user
  belongs_to :course
  belongs_to :group

  attr_accessible :user, :course, :group

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

    "#{(self.user.nil?) ? "Deleted user" : self.user.display_name} has enrolled to #{(self.course.nil?) ? "Deleted Course" : self.course.title}"

  end

  def to_s
    if self.group
      "#{(self.user.nil?) ? "Deleted User" : self.user.name} #{self.group}"
    else
      "#{(self.user.nil?) ? "Deleted User" : self.user.name} - #{self.user.degree_programs.collect{|prog| "#{prog.degree} #{prog.name} (#{prog.faculty.short_name})"}.join(", ")}"
    end
  end

end
