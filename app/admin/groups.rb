ActiveAdmin.register Group do
  menu :parent => "Courses"
  filter :course
  index do
    selectable_column
    column :id
    column 'Tutor', :user
    column :course
    column 'Users' do |group|
      group.users.count
    end
    default_actions
  end

  show do |group|
    attributes_table do
      row :id
      row :user
      row :course
    end

    panel pluralize group.users.count, "User" do
      table_for group.users do |user|
        column :name
      end
    end
  end

  form do |f|
    f.inputs 'Group' do
      if f.object.new_record?
        f.input :user, collection: Hash[User.where('role >= ?', User::ROLES[:tutor]).map{|user| ["#{user.name} <#{user.email}>",user.id]}], :label => "Tutor"
        f.input :course
      else
        f.input :user
        f.input :course
        sorted = Enrollment.all(joins: {user: :test_results}, conditions: {course_id: f.object.course.id, 'test_results.course_id' => f.object.course.id}, order: 'test_results.score ASC')
        f.input :enrollments, as: :check_boxes, collection: sorted + (Enrollment.where('course_id = ?', f.object.course.id) - sorted)
      end
    end
    f.actions
  end

end
