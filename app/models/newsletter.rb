class Newsletter < ActiveRecord::Base
  #has_and_belongs_to_many :degree_programs
  has_many :newsletter_maps
  #has_many :receiver_groups, :through => :newsletter_maps, :source => :receiver_group
  has_many :degree_programs, :through => :newsletter_maps, :source => :receiver_group, :source_type => 'DegreeProgram'
  has_many :courses, :through => :newsletter_maps, :source => :receiver_group, :source_type => 'Course'
  has_many :groups, :through => :newsletter_maps, :source => :receiver_group, :source_type => 'Group'

  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id', :validate => true
  belongs_to :last_receiver, :class_name => 'User', :foreign_key => 'last_receiver_id', :validate => true

  has_many :group_users, :through => :groups, :source => :users, :uniq => true
  has_many :degree_program_users, :through => :degree_programs, :source => :users, :uniq => true
  has_many :course_users, :through => :courses, :source => :users, :uniq => true

  attr_accessible :content, :subject, :degree_program_ids, :course_ids, :group_ids, :all_users, :no_degree_programs

  def sent?
  	state == "sent"
  end

  def sending?
    state == "sending"
  end

  def all_receivers
    if self.all_users.nil? || self.all_users == 0 
      #UNION all possible user sources
      all_users = User.from("(#{self.degree_program_users.to_sql} UNION #{self.group_users.to_sql} UNION #{self.course_users.to_sql}) AS users")

      #Incl. no degree_programs:
      all_users = User.from("(#{User.without_degree_programs.to_sql} UNION #{all_users.to_sql}) AS users") if self.no_degree_programs == 1
      return all_users
    else
      return User.order("id")
    end
  end

  def missing_receivers
    self.last_receiver_id = 0 if last_receiver_id.nil?
    self.all_receivers.uniq.where("users.id > #{self.last_receiver_id}").order("users.id")
  end

  def done_percentage
    100-((100.0*missing_receivers.count) / (1.0 * all_receivers.count))
  end

  def deliver
    send_to_users = self.missing_receivers

    send_to_users.each do |user|
       user.send_newsletter self

       Newsletter.find(self.id).update_attribute(:last_receiver_id, user.id) #Going this way, in order to write outside the delayed job
    end

  	self.state = "sent"
    self.delivered_at = Time.zone.now
  	self.save!
  end


end
