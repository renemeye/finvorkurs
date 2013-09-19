# encoding: utf-8
require 'spec_helper'
describe Group do
  	it "should have markdown group information" do
  		course1 = Course.create(title: "Kurs 1", course_level: "Grundkurs");

	  	tutor1 = create(:tutor)
	  	tutor2 = create(:tutor)

	  	group1 = create :group, :user => tutor1, :course => course1, :group_information => "Hallo **Welt** end";

	  	group1.markdown_group_information.should include("Hallo <strong>Welt</strong> end");
  	end

  	it "should be named like the course if the course has only one group" do
  		course1 = Course.create title: "Tester 1", course_level: "Spezialisierungskurs"
  		course2 = Course.create title: "Tester enhanced", course_level: "Spezialisierungskurs"

  		tutor1 = create(:tutor)
	  	tutor2a = create(:tutor)
	  	tutor2b = create(:tutor)

  		group1 = create(:group, :user => tutor1, :course => course1)
  		group2a = create(:group, :user => tutor2a, :course => course2)
  		group2b = create(:group, :user => tutor2b, :course => course2)

  		group1.to_s.should eq("#{course1.course_name}")

  		group2a.to_s.should eq("Spezialisierungskurs: #{tutor2a.name}")

  	end
end