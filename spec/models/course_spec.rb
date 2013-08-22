require 'spec_helper'

describe Course do
  it "knows all Course levels" do 
  	course1 = Course.create(title: "Kurs 1", course_level: "Grundkurs");
  	course2 = Course.create(title: "Kurs 2", course_level: "Spezialkurs");
  	course3 = Course.create(title: "Kurs 3", course_level: "Spezialkurs");
  	course4 = Course.create(title: "Kurs 4", course_level: "Spezialkurs");

  	Course.course_levels.should eq(["Grundkurs", "Spezialkurs"])

  end
end
