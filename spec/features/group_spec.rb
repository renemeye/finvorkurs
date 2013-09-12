# encoding: utf-8
require 'spec_helper'

describe Group do
	it "should create two balanced groups" do
	  	course1 = Course.create(title: "Kurs 1", course_level: "Grundkurs");

	  	tutor1 = create(:tutor)
	  	tutor2 = create(:tutor)

	  	group1 = create(:group, :user => tutor1, :course => course1)
	  	group2 = create(:group, :user => tutor2, :course => course1)

	    fak1 = create(:faculty_with_programs, name: "Fak1")
	    fak2 = create(:faculty_with_programs, name: "Fak2")

	    user1Fak1 = create(:user, :degree_program_ids => [fak1.degree_programs.first.id])
	    user2Fak1 = create(:user, :degree_program_ids => [fak1.degree_programs.first.id])
	    user3Fak1 = create(:user, :degree_program_ids => [fak1.degree_programs.first.id])
	    user4Fak1 = create(:user, :degree_program_ids => [fak1.degree_programs.first.id])
	    user1Fak2 = create(:user, :degree_program_ids => [fak2.degree_programs.first.id])
	    user2Fak2 = create(:user, :degree_program_ids => [fak2.degree_programs.first.id])

	    user1Fak1.courses << course1
	    user2Fak1.courses << course1
	    user3Fak1.courses << course1
	    user4Fak1.courses << course1
	    user1Fak2.courses << course1
	    user2Fak2.courses << course1

	    Group.initialize_groups_for_course course1

	    group1.users.should eq([user1Fak1,user2Fak1,user3Fak1])
	    group2.users.should eq([user4Fak1,user1Fak2,user2Fak2])

		#It should not chreate a new enrollemnt
	    user1Fak1.enrollments.last.course.should_not eq(nil)

  	end


  	it "should create two not balanced groups" do
	  	course1 = Course.create(title: "Kurs 1", course_level: "Grundkurs");

	  	tutor1 = create(:tutor)
	  	tutor2 = create(:tutor)

	  	group1 = create(:group, :user => tutor1, :course => course1)
	  	group2 = create(:group, :user => tutor2, :course => course1)

	    fak1 = create(:faculty_with_programs, name: "Fak1")
	    fak2 = create(:faculty_with_programs, name: "Fak2")

	    user1Fak1 = create(:user, :degree_program_ids => [fak1.degree_programs.first.id])
	    user2Fak1 = create(:user, :degree_program_ids => [fak1.degree_programs.first.id])
	    user3Fak1 = create(:user, :degree_program_ids => [fak1.degree_programs.first.id])
	    user4Fak1 = create(:user, :degree_program_ids => [fak1.degree_programs.first.id])
	    user1Fak2 = create(:user, :degree_program_ids => [fak2.degree_programs.first.id])
	    user2Fak2 = create(:user, :degree_program_ids => [fak2.degree_programs.first.id])
	    user3Fak2 = create(:user, :degree_program_ids => [fak2.degree_programs.first.id])

	    user1Fak1.courses << course1
	    user2Fak1.courses << course1
	    user3Fak1.courses << course1
	    user4Fak1.courses << course1
	    user1Fak2.courses << course1
	    user2Fak2.courses << course1
	    user3Fak2.courses << course1

	    Group.initialize_groups_for_course course1

	    group1.users.should eq([user1Fak1,user2Fak1,user3Fak1, user4Fak1])
	    group2.users.should eq([user1Fak2,user2Fak2,user3Fak2])

	    #It should not chreate a new enrollemnt
	    user1Fak1.enrollments.last.course.should_not eq(nil)

  	end
end