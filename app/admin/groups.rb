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
    column 'Present' do |course|
      group.users.to_a.count{|u|u.present}
    end
    column 'Teilnehmer', :readable_group_scope
    column :room
    default_actions
  end

  show do |group|
    attributes_table do
      row :id
      row :user
      row :course
      row :readable_group_scope
      row "Group Information" do |group|
        raw group.markdown_group_information
      end
    end

    panel pluralize group.users.count, "User" do
      table_for group.users do |user|
        column :name
        column :email
        column "Interessiert an" do |user|
          ul do
            user.degree_programs.each do |prog|
              li "#{prog.degree} #{prog.name} (#{prog.faculty.short_name})"
            end
          end
        end
      end
    end
  end

  form do |f|
    f.inputs 'Group' do
      f.input :user, collection: Hash[User.where('role >= ?', User::ROLES[:tutor]).map{|user| ["#{user.name} <#{user.email}>",user.id]}], :label => "Tutor"
      f.input :course
      f.input :room
      f.input :group_information, :hint => "Markdown support"
      unless f.object.new_record?
        users_in_this_or_without_group = Enrollment.from("(#{f.object.enrollments.to_sql} UNION #{f.object.course.enrollments.where("enrollments.group_id IS ?",nil).to_sql}) AS enrollments")
        f.input :enrollments, as: :check_boxes,  collection: users_in_this_or_without_group
      end
    end
    f.actions
  end

end
