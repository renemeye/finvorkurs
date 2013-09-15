require 'spec_helper'

describe Course do
  it "knows all Course levels" do 
  	course1 = Course.create(title: "Kurs 1", course_level: "Grundkurs");
  	course2 = Course.create(title: "Kurs 2", course_level: "Spezialkurs");
  	course3 = Course.create(title: "Kurs 3", course_level: "Spezialkurs");
  	course4 = Course.create(title: "Kurs 4", course_level: "Spezialkurs");

  	Course.course_levels.should eq(["Grundkurs", "Spezialkurs"])

  end
  
  it "should return good users_grouped_by_faculty_and_programs" do
  	course1 = Course.create(title: "Kurs 1", course_level: "Grundkurs");

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

    course1.users.should include(user3Fak1)

    user2Fak2.faculties.should include(fak2)

    course1.get_users_grouped_by_faculty_and_programs.should eq({
      fak1 => { fak1.degree_programs.first => [user1Fak1,user2Fak1,user3Fak1,user4Fak1] }, 
      fak2 => {fak2.degree_programs.first => [user1Fak2,user2Fak2] } 
    })

  end

  it "should have a list with users in groups and without groups" do
    course1 = create(:course_with_groups)

    old_user1 = create(:user)
    old_user2 = create(:user)
    old_user3 = create(:user)

    new_user1 = create(:user)
    new_user2 = create(:user)

    old_user1.courses << course1
    old_user2.courses << course1
    old_user3.courses << course1

    Group.initialize_groups_for_course(course1)

    course1.users_with_group.should eq([old_user1, old_user2, old_user3])
    course1.users_without_group.should eq([])

    new_user1.courses << course1
    new_user2.courses << course1

    course1.users_with_group.should eq([old_user1, old_user2, old_user3])    
    course1.users_without_group.should eq([new_user1,new_user2])

  end

end
