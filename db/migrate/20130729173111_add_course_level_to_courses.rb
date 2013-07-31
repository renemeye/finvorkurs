class AddCourseLevelToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :course_level, :string
  end
end
